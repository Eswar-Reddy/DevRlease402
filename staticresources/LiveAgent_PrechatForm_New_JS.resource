var prechat = (function () {
    
    if(typeof console === "undefined") {
        console = { log: function() { } };
    }
    
    var isIEorFF = false;
    
    // ************************
    // Javascript function for CASESAFEID: get 18-char Id from the 15-char Id
    // ************************
    (function (w) {
        w.normalizeId = function (id) {
            var i, j, flags, alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345",
                isUppercase = function(c) {
                    return c >= "A" && c <= "Z";
                };
    
            if (id == null) return id;
            id = id.replace(/\W/g, "");
            if (id.length != 15) { return id; }
    
            for (i = 0; i < 3; i++) {
                flags = 0;
                for (j = 0; j < 5; j++) {
                    if (isUppercase(id.charAt(i * 5 + j))) { flags += 1 << j; }
                }
                id += alphabet.charAt(flags);
            }
            return id;
        }
    })(window);

    // ************************
    // Global variables
    // ************************
    var settings;
    var selectedRule;
    
    // For collapsible routing menu
    // The 'accordion' boolean is used to deactivate the accordion when using search
    var accordion = true;
    
    // ************************
    // Override jQuery contains() selector to be case insensitive
    // ************************
    $.expr[":"].contains = $.expr.createPseudo(function(arg) {
        return function( elem ) {
            return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
        };
    });
    
    // ************************
    // This script takes the endpoint URL parameter passed from the deployment page and makes it the action for the form
    // ************************
    (function() {
        function handlePageLoad() {
            var endpointMatcher = new RegExp("[\\?\\&]endpoint=([^&#]*)");
            var currEndpointURL = decodeURIComponent(endpointMatcher.exec(document.location.search)[1]);
            $('#prechatForm').attr('action', decodeURIComponent(currEndpointURL));
        }
        if (window.addEventListener) {
            window.addEventListener('load', handlePageLoad, false);
        } else {
            window.attachEvent('onload', handlePageLoad, false);
        }
    })();
    
    // ************************
    // In IE 10 / 11 and FF, the popup does not have any scrollbar, 2 div tags with Id body2 and body3 allow to show the scrollbar
    // the vertical scrollbar is manually body2 based on the height of body3
    // ************************
    function setupContentForIE() {
        var $body = $('body');
        var $bodyContent = $body.children();
        var $body2 = $('<div></div>').attr('id', 'body2').appendTo($body);
        var $body3 = $('<div></div>').attr('id', 'body3').appendTo($body2);
        $body.css('padding-right', '0px');
        $body.css('padding-left', '0px');
        $bodyContent.detach().appendTo($body3);
        $body2.css('height', $(window).height());
        window.onresize = function() {
            console.log('window.onresize');
            $body2.css('height', $(window).height());
        };
    }
    
    // ************************
    // Compare options and optgroups tags for sort purpose
    // ************************
    function compareOptions(a,b) {
        var an, bn;
        if (a.tagName === 'option') {
            an = a.innerText;
        } else {
            an = a.label;
        }
        if (b.tagName === 'option') {
            bn = b.innerText;
        } else {
            bn = b.label;
        }
    
        if(an > bn) {
            return 1;
        }
        if(an < bn) {
            return -1;
        }
        return 0;
    }
    
    // ************************
    // Sort options and optgroups in select tags
    // ************************
    function sortSelect($element) {
        var $options = $element.children('option:not(.placeholder)');
    
        $options.sort(compareOptions);
        $options.detach().appendTo($element);
        
        var $optgroups = $element.children('optgroup');
        $optgroups.sort(compareOptions);
        $optgroups.detach().appendTo($element);
        
        $optgroups.each(function() {
            sortSelect($(this));
        });
    }
    
    // ************************
    // Compare routing rules
    // ************************
    function compareRoutingRules(a,b) {
        var an, bn;
        if (a.Group__c === b.Group__c) {
            an = a.RoutingLabel__c;
            bn = b.RoutingLabel__c;
        } else {
            an = a.Group__c;
            bn = b.Group__c;
        }
    
        if(an > bn) {
            return 1;
        }
        if(an < bn) {
            return -1;
        }
        return 0;
    }
    
    // ************************
    // Show message informing agents are not available
    // Based of DOM changes tracking: if a chat button changes status, this method is trigerred
    // ************************
    function showMessageOnOffline() {
        $('[id^="button_"]').attrchange({
            trackValues: false,
            callback: function(e) {
                if ($('[id^="button_offline_"]:not([style*="none"])').length > 0) {
                    $('#offlineButtonAlert').css('visibility', '');
                } else {
                    $('#offlineButtonAlert').css('visibility', 'hidden');
                }
                // On first load, display the routing menu when the online/offline buttons are defined
                if ($('[id*=routingBlock]').is(':hidden')
                    && $('[id^="button_"]:not([style*="none"])').length > 0
                    && selectedRule == null) {
                    console.log('Showing routingBlock with number of visible buttons: ' + $('[id^="button_"]:not([style*="none"])').length);
                    $('#contentLoading').hide();
                    $('#title').show();
                    $('[id*=routingBlock]').show();
                    $('#disclaimer').show();
                }
            }
        });
    }
    
    // ************************
    // Get the managing button id (i.e. the last button id is the list as it contains all agents in all teams assign to the button)
    // ************************
    function getManagingButtonId(rule) {
        return rule.ChatButtonID__c.slice(-15);
    }
    
    // ************************
    // Add button listener: listen to chat button availability
    // Don't forget to initiate liveagent and window._laq
    // ************************
    function addButtonListener(routingRule) {
        window._laq.push(function() {
            console.log('addButtonListener for: ' + routingRule.Name + ' with button: ' + getManagingButtonId(routingRule));
            liveagent.showWhenOnline(getManagingButtonId(routingRule), document.getElementById('button_online_' + routingRule.Name));
            liveagent.showWhenOffline(getManagingButtonId(routingRule), document.getElementById('button_offline_' + routingRule.Name));
        });
    }
    
    // ************************
    // Create routing rule for Collapsible Routing Menu
    // ************************
    function createCollapsibleItem(routingRule) {
        var $listItem = $('<li></li>').addClass('list-group-item');
        
        var $onlineAnchor = $('<a></a>').appendTo($listItem);
        $onlineAnchor.text(routingRule.RoutingLabel__c);
        $onlineAnchor.attr('id', 'button_online_' + routingRule.Name);
        $onlineAnchor.attr('routing-rule', routingRule.Name);
        $onlineAnchor.attr('button-id', routingRule.ChatButtonID__c);
        $onlineAnchor.hide();
        
        var $offlineSpan = $('<span></span>').appendTo($listItem);
        $offlineSpan.text(routingRule.RoutingLabel__c);
        $offlineSpan.attr('id', 'button_offline_' + routingRule.Name);
        $offlineSpan.hide();
        
        return $listItem;
    }
    
    // ************************
    // Create routing group for Collapsible Routing Menu
    // ************************
    function createCollapsibleGroup(groupName, firstRuleName) {
        var $panelDefault = $('<div></div>').addClass('panel panel-default');
        
        var $panelHeading = $('<div></div>').addClass('panel-heading').appendTo($panelDefault);
        
        var $title = $('<h4></h4>').addClass('panel-title').appendTo($panelHeading);
        
        var $titleAnchor = $('<a></a>').addClass('collapsed').appendTo($title);
        $titleAnchor.attr('data-toggle', 'collapse');
        $titleAnchor.attr('href', '#' + firstRuleName);
        $titleAnchor.text(groupName);
        
        var $panelCollapse = $('<div></div>').addClass('panel-collapse collapse').appendTo($panelDefault);
        $panelCollapse.attr('id', firstRuleName);
        
        var $listGroup = $('<ul></ul>').addClass('list-group').appendTo($panelCollapse);
        
        return $panelDefault;
    }
    
    // ************************
    // Create Collapsible Routing Menu
    // ************************
    function createCollapsibleMenu(routingRules) {
        var $routingBlockDiv = $('<div></div>').appendTo($('[id*=routingBlock]'));
        $routingBlockDiv.addClass('panel-group');
        
        var $curPanelDefault, curGroupName;
        $.each(routingRules, function(index, rule) {
            if (rule.Group__c !== curGroupName) {
                curGroupName = rule.Group__c;
                $curPanelDefault = createCollapsibleGroup(curGroupName, rule.Name).appendTo($routingBlockDiv);
            }
            $curPanelDefault.find('.list-group').append(createCollapsibleItem(rule));
            addButtonListener(rule);
        });
        
        // Enable Accordion: when a panel is uncollapsed, the other panels automatically collaspe
        $('.collapse').on('show.bs.collapse', function () {
            if (accordion) $('.collapse').not(this).collapse('hide');
        });
    }
    
    // ************************
    // Create routing rule for Routing Table Menu
    // ************************
    function addRoutingRuleRow(routingRule, $table) {
        var buttonLabel;
        if (routingRule.Group__c == null || routingRule.Group__c.length == 0) {
            buttonLabel = routingRule.RoutingLabel__c;
        } else {
            buttonLabel = routingRule.Group__c;
        }
        
        // Create a row for online content with the id of the online button
        var $row = $('<tr></tr>').appendTo($table);
        $row.attr('id' ,'button_online_' + routingRule.Name).hide();
        
        // Create the unique cell in the row
        var $cell = $('<td></td>').appendTo($row);
        
        // Create a first span to contain the button
        var $span = $('<span></span>').appendTo($cell);
        
        // Create the online button and add it to the first span
        var $button = $('<a></a>').appendTo($span);
        $button.attr('routing-rule', routingRule.Name).text(buttonLabel);
        
        // Create the second span with the description and add it to the unique cell in the row
        $span = $('<span></span>').appendTo($cell);
        //var $description = $('<span></span>').appendTo($cell);
        $span.html(routingRule.RoutingLabel__c);
        
        // Create a row for offline content with the id of the offline button
        $row = $('<tr></tr>').appendTo($table);
        $row.attr('id' ,'button_offline_' + routingRule.Name).hide();
        
        // Create a unique cell to contain the offline content
        $cell = $('<td></td>').appendTo($row);
        
        // Create the first span with the offline button (using div)
        $span = $('<span></span>').appendTo($cell);
        $button = $('<div></div>').appendTo($span);
        $button.attr('routing-rule', routingRule.Name).text(buttonLabel);
        
        // Create a second span with the description
        $span = $('<span></span>').appendTo($cell);
        $span.html(routingRule.RoutingLabel__c);
    }
    
    // ************************
    // Create routing rule for Routing Table Menu
    // ************************
    function createRoutingMenuTable(routingRules) {
        var $routingBlockDiv = $('<div></div>').appendTo($('[id*=routingBlock]'));
            
        var $routingTable = $('<table></table');
        $routingTable.attr('id', 'routingTable');
        $routingBlockDiv.append($routingTable);
        
        $.each(routingRules, function(index, rule) {
            addRoutingRuleRow(rule, $routingTable);
            addButtonListener(rule);
        });
    }
    
    // ************************
    // Enable search function for routing menu
    // ************************
    function enableSearch() {
        $('#search').keyup(function() {
            var search = $(this).val();
            if (search.length > 0) {
                // Restore css modification
                $('li:visible:first').css('border-top-style','');
                
                // Disable the accordion
                accordion = false;
                
                // Uncollapse all the lists to ease the selection
                //$('.collapse').collapse('hide');
                $('.collapse').collapse('show');
                
                // In case of erase, show again all content
                $('li, [id*=routingBlock] td').show();
                $('li:visible:first').css('border-top-style','');
                
                // For collapsible menu
                // Find all the list items not containing the search string and hide them
                //$('li :not(:contains("' + search + '"))').parent('li').hide();
                var searchStrings = search.split(' ');
                var excludeSelector = 'li :not(';
                $.each(searchStrings , function (index, s) {
                    if (s !== null && s.length > 0) {
                        excludeSelector += ':contains("' + s + '")';
                    }
                });
                excludeSelector += ')';
                console.log('excludeSelector: ' + excludeSelector);
                $(excludeSelector).parent('li').hide();
                
                $('li:visible:first').css('border-top-style','none');
                
                // For the table menu
                // Find all the rows (tr) containing the search string (it can be the button label or the description)
                var $searchResults = $('[id*=routingBlock] td :contains("' + search + '")').parents('tr');
                
                // Find all the tr and remove the ones containing the search string
                // Then hide the children as the rows are already used to hide online / offline content
                $('[id*=routingBlock] tr').not($searchResults).children('td').hide();
            } else {
                // Restore css modification
                $('li:visible:first').css('border-top-style','');
                
                // Enable the accordion
                accordion = true;
                //$('.panel-title a').attr('data-toggle', 'collapse');
                
                // Collapse all panels
                $('.collapse').collapse('hide');
                
                // Show all previously hidden values
                $('li, [id*=routingBlock] td').show();
            }
        });
    }
    
    // ************************
    // Setup the routing menu
    // ************************
    function setupRoutingMenu() {
                
        liveagent.init('https://d.' + settings.EndpointId + '.salesforceliveagent.com/chat', settings.DeploymentId, settings.OrgId);
        if (!window._laq) {
            window._laq = [];
        }
        
        var routingRules = $.map(settings.RoutingRulesMap, function(value, index) {
            return [value];
        });
        
        routingRules.sort(compareRoutingRules);
        
        // Check if Collapsible Menu is enabled
        if (settings.Form.AdvancedRoutingMenu__c) {
            createCollapsibleMenu(routingRules);
        } else {
            createRoutingMenuTable(routingRules);
        }
        
        showMessageOnOffline();
    
		enableSearch();
        
        // Associate the chat button with the select function
        $('a[routing-rule]').click(function() {
            select($(this).attr('routing-rule'));
        });
    }
    
    
    // ************************
    // Show the page with its content
    // ************************
    function showPage() {
        if (settings.Form.IsRoutingMenuVisible__c) {
            setupRoutingMenu();
        } else {
            showPrechatForm();
        }
        //$('#disclaimer').show();
    }
    
    // ************************
    // Manage visibility of Order Number, Model Number and Serial Number
    // If Routing menu is enabled, the visibilty is defined by the selected routing rule
    // Otherwise it is defined by the form settings
    // Order Number can be hidden or visible, and mandatory or not
    // Model Number and Serial Number can only be visible or hidden
    // ************************
    function manageDependentVisibility(ruleOrForm) {
        $('#contentLoading').hide();
        $('#title').show();
        $('#disclaimer').show();
        
        if (ruleOrForm.IsOrderNumberVisible__c) {
            $('#rowOrderNumber').show();
            if (ruleOrForm.IsOrderNumberMandatory__c) {
                $('#rowOrderNumber').find('label').addClass('mandatory');
                $('#rowOrderNumber').find('label').text($('#orderNumberLabel').val() + ' ');
            }
        } else {
            $('#rowOrderNumber').remove();
        }
        if (ruleOrForm.AreProductFieldsVisible__c ) {
            $('.rowProductFields').show();
        } else {
            $('.rowProductFields').remove();
        }
    }
    
    // ************************
    // Show the prechat-form with its content
    // ************************
    function showPrechatForm() {
        if (settings.Form.IsRoutingMenuVisible__c) {
            manageDependentVisibility(selectedRule);
        } else {
            manageDependentVisibility(settings.Form);
        }
        
        if ($('#prechatForm table.main').text().trim().length === 0) {
            submitForm();
            return;
        } else if (settings.Form.IsRoutingMenuVisible__c) {
            $('#back').show();
        }
        
        // -- Sort list of values --
        sortSelect($('#sChatCategory'));
        //sortSelect($('#sRoutingMenu'));
        
        $('#prechatForm').show();
        $('#disclaimer').show();
        
        // -- Setup Select2 --
        // Remove content of the first option to setup the placeholder with Select2
        $('.placeholder').text('');
        
        // Retrieve the label for the placeholder in Select2
        var placeholderLabel = $('#placeholderLabel').val();
        $('select').select2({
            placeholder: placeholderLabel,
            allowClear: false,
            minimumResultsForSearch: Infinity
        });
    }
    
    // ************************
    // Manage click on one of the button from the Advanced Routing Menu
    // ************************
    function select(routingRuleName) {
        selectedRule = settings.RoutingRulesMap[routingRuleName];
        console.log('selectedRule: ' + JSON.stringify(selectedRule));
        
        $('[id*=routingBlock]').hide();
        
        // Manage advanced 'Routing Menu' (buttons table version)
        // Copy the label of selected Routing Value in the specific hidden field, to be displayed to the agent
        if (settings.Form.AdvancedRoutingMenu__c || selectedRule.Group__c == null || selectedRule.Group__c.length === 0) {
            $('#sRoutingChoice').val(selectedRule.RoutingLabel__c);
        } else {
            $('#sRoutingChoice').val(selectedRule.Group__c);
        }
        // Copy the value of selected Routing Value in the specific hidden field, to route the customer to the right team
        $('#sChatButtons').val(selectedRule.ChatButtonID__c);
        
        showPrechatForm();
    }
    
    // ************************
    // Check email field format
    // ************************
    function isEmail(emailStr) {
        var email = emailStr;
        var verif = /^([a-zA-Z0-9_-])+([.]?[a-zA-Z0-9_-]{1,})*@([a-zA-Z0-9-_]{2,}[.])+[a-zA-Z]{2,3}$/;
        if (verif.exec(email) == null) {
            return false;
        }
        else{
            return true;
        }   
    }       
    
    // *************************
    // Check number field format
    // *************************
    function isNumber(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }
    
    // **************************
    // Validate & submit the form
    // **************************
    var submitForm = function() {
        var error = false;
        
        $('input').each(function() {
            $(this).val($(this).val().trim());
        });
        
        // Check mandatory fields
        $('#prechatForm td .mandatory:first-child').each(function() {
            if ($(this).next().val() == '') {
                $(this).addClass('inputError');
                error = true;
            } else {
                $(this).removeClass('inputError');
            }
        });
        
        // Manage display to agent
        $('.main td input:nth-child(2), #sChatCategory').each(function() {
            var fieldName = $(this).attr('name');
            if (typeof attr !== typeof undefined && attr !== false) {
                fieldName = fieldName.replace('liveagent.prechat:', 'liveagent.prechat.findorcreate.displayToAgent:');
                $("input[name='" + fieldName + "']").val($(this).next().val() != '');
            }
        });
        
        // Check 'Email'
        if (settings.Form.IsEmailVisible__c) {
            if (isEmail($('#sEmail').val())) {
                $('#labelEmail').removeClass('inputError');
            } else {
                $('#labelEmail').addClass('inputError');
                error = true;  
            }
        }
        
        // Check 'Zip Code'        
        if (settings.Form.IsZipCodeVisible__c 
         && $('#sZipCode').val() != ''
         && $('#sZipCode').val().length >= settings.Form.ZipCodeMinimumLength__c) {
            $('#labelZipCode').removeClass('inputError');
        } else if (settings.Form.IsZipCodeMandatory__c) {
            $('#labelZipCode').addClass('inputError');
            error = true;
        }
        
        // Check 'Privacy Policy'
        if (settings.Form.IsPrivacyPolicyAcceptationRequired__c && settings.Form.PrivacyPolicyLink__c != '') {
            if ($('#sPrivatePolicy').prop('checked')) {
                $('#labelPrivacyPolicy').removeClass('inputError');
                $('#sPrivatePolicy').val(1);
                $('#errorPrivacy').hide();
            } else {
                $('#labelPrivacyPolicy').addClass('inputError');
                $('#sPrivatePolicy').val(0);
                error = true;
                $('#errorPrivacy').show();
            }
        }
        
        // Manage label of 'Title' to be displayed to agent
        if (settings.Form.IsTitleVisible__c && $('#sTitle').val() != '') {
            // Copy the label of selected Title in the specific hidden field, to be displayed to the agent
            var sTitleText = $('#sTitle option:selected').text();
            $('#sTitleLabel').val(sTitleText);
        }
        
        // Match Email Opt In
        console.log('Match Email Opt In');
        if (settings.Form.DisplayEmailOptIn__c) {
            if ($('#sWebEmailOptIn').prop('checked')){
                console.log('Email Opt In is YES');
                $('#sEmailOptIn').val('Yes');
                $('#sEmailOptInCode').val('Y');
            } else {
                console.log('Email Opt In is NO because of unchecked');
                $('#sEmailOptIn').val('No');
                $('#sEmailOptInCode').val('N');
            }
        } else {
            if (settings.Form.DisplayNonCommercialUsageMessage__c){
                // Display Non Commercial Usage Message, then Email Opt In = No
                console.log('Email Opt In is NO');
                $('#sEmailOptIn').val('No');
                $('#sEmailOptInCode').val('N');
            } else {
                // Email Opt In = Unknown
                console.log('Email Opt In is UNKNOWN');
                $('#sEmailOptIn').val('Unknown');
                $('#sEmailOptInCode').val('U');
            }
        }
        
        // Populate Managing Chat Button Id (API Name = SourceChatButtonId__c)
        if (settings.Form.IsRoutingMenuVisible__c) {
            // If routing menu enabled
            // get the first id in sChatButtons (from selected routing choice)
            var managingButtonId = normalizeId($('#sChatButtons').val().split(',')[0]);
            $('#sManagingButtonId').val(managingButtonId);
        } else if (settings.Form.ChatButtonIds__c != null && settings.Form.ChatButtonIds__c.length > 0) {
            // If fall back routing is enabled i.e. Chat Buttons by Priority (settings.Form.ChatButtonIds__c) is not empty
            // get the first id in settings.Form.ChatButtonIds__c
            var managingButtonId = normalizeId(settings.Form.ChatButtonIds__c.split(',')[0]);
            $('#sManagingButtonId').val(managingButtonId);
        } else {
            // otherwise assign reporting button id to reporting button id
            $('#sManagingButtonId').val($('#sReportingButtonId').val());
        }
        
        // Is there any error?
        if (!error) {
            $('#error').hide();
            
            // Fill Chat visitor name in
            if (settings.Form.SetName__c != null && settings.Form.SetName__c.length > 0) {
                var visitorName = settings.Form.SetName__c;
                visitorName = visitorName.replace("Title", $('#sTitleLabel').val());
                visitorName = visitorName.replace("FirstName", $('#sFirstName').val());
                visitorName = visitorName.replace("LastName", $('#sLastName').val());
                $('#sVisitorName').val(visitorName);
            }
            
            $('#title').hide();
            $('#prechatForm').hide();
            $('#disclaimer').hide();
            $('#contentLoading').show();
            
            // if Auto Create Consumer search for exisiting contacts with the email first
            if (settings.Form.AutoCreateConsumers__c) {
                try {
                    var email = $('#sEmail').val();
                    console.log('isContactOnlyExisting with email = ' + email);
                    VFC_LiveAgent_PrechatForm_New.isContactOnlyExisting(email,
                        function(result, event) {
                            console.log('isContactOnlyExisting: ' + result);
                            if (!result) {
                                var $inputDoCreateAccount = $('<input />');
                                $inputDoCreateAccount.attr('type', 'hidden');
                                $inputDoCreateAccount.attr('name', 'liveagent.prechat.findorcreate.map.doCreate:Account');
                                $inputDoCreateAccount.val('RecordTypeId,true;Salutation,true;FirstName,true;LastName,true;PersonEmail,true;PersonMobilePhone,true;BillingZipCode,true;BillingCountryCode,true;CorrespLang__pc,true;MarcomPrefEmail__pc,true;');
                                $('#doCreateAccount').append($inputDoCreateAccount);
                            }
                        
                            // Submit the form
                            document.myform.submit();
                        }, 
                        {escape:true}
                    );
                } catch(ex) {
                    alert(ex.message);
                }
            } else {
                // Submit the form
                document.myform.submit();
            }
            
        } else {
            $('#error').show();
        }
    }
    
    // ************************
    // jQuery Ready function
    // ************************
    $(function() {
        if (navigator.userAgent.indexOf('MSIE') > -1
           || navigator.userAgent.indexOf('Trident') > -1
           || navigator.userAgent.indexOf('Firefox') > -1) {
            isIEorFF = true;
            setupContentForIE();
        }
        
        $('#back a').on('click', function() {
            $('#prechatForm').hide();
			$('[id*=routingBlock]').show();
        });
        
        settings = jQuery.parseJSON($('#settingsJSON').text());
        showPage();
    });
    
    return {
        submitForm: submitForm
    }
    
})();