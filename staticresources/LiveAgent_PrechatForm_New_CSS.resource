body {
    padding: 0 1em 15px;
}

#body2 {
    overflow-y: auto;
}

#body3 {
    padding: 0 1em 15px;
}

#prechatForm {
    display: none;
}

#prechatForm, [id*=routingTable] {
    height: auto;
	overflow: visible;
    margin: 0 auto;
}

* {
    font-family: 'Arial Rounded', 'Lucida Grande', Lucida, 'Lucida Sans Unicode', sans-serif;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
}

#prechatForm #back {
    display: none;
    color: #42b4e6;
    font-weight: bold;
    padding-bottom: 7px;
}

#prechatForm #back a {
    font-size: 11px;
	color: #3ba2ce;
}

table {
    clear: both;
    background: transparent;
    width: 100%;
}

#prechatForm a {
    color: #666;
}

#livechat a:hover {
    cursor: pointer;
}

#error {
    color: red;
    font-size: 0.85em;
    margin-bottom: 0;
}

#errorPrivacy {
    display: none;
    font-size: 0.85em;
    margin-top: 0;
}

#contentLoading {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    -ms-transform: translate(-50%, -50%);
}

#contentLoading>div {
    text-align: center;
}

#livechat h2 {
    box-sizing: border-box;
    display: none;
    width: 100%;
    color: #009530;
    font-size: 2em;
    margin: .1em 0;
    text-align: center;
    margin-top: 15px;
    margin-bottom: 15px;
    font-family: 'Arial Rounded', 'Lucida Grande', Lucida, 'Lucida Sans Unicode', sans-serif;
}

#livechat h3 {
    font-size: 0.85em;
    text-align: left;
    font-weight: 100;
    font-family: 'Arial Rounded', 'Lucida Grande', Lucida, 'Lucida Sans Unicode', sans-serif;
    /*padding: 10px 0 10px 0;*/
    /*margin: 10px 0 10px 0;*/
}

#livechat h4 {
    font-size: 0.90em;
}

#livechat h4 a {
    font-weight: 100;
}

.icon-bubble {
    display: inline-block;
    height: 1.2em;
    width: 1.2em;
    margin-right: .5em;
    background-size: contain;
    background-repeat: no-repeat;
    vertical-align: middle;
}

#prechatForm input, .select2-container--default .select2-selection--single {
    border-radius: 1px;
    border: 1px solid #9fa0a4;
    color: #9fa0a4;
    -webkit-box-shadow: none;
    box-shadow: none;
    padding: .4em;
    line-height: 1.2em;
    font-size: .8em;
    display: block;
    width: 100%;
    vertical-align: middle;
}

.select2-container--default .select2-selection--single {
    padding: 0px !important;
    color: #9fa0a4;
}

.select2-container--default, .select2-container--focus {
    width: 100% !important;
}

.select2-container--default .select2-selection--single .select2-selection__rendered {
    padding-left: .4em !important;
    color: #9fa0a4;
}

.select2-dropdown {
    border-radius: 1px !important;
    border: 1px solid #9fa0a4;
    color: #9fa0a4;
    -webkit-box-shadow: none;
    box-shadow: none;
    padding: .4em !important;
    line-height: 1em !important;
    font-size: .8125em !important;
}

ul li, ol li {
    margin-left: 1em
}

.mandatory:after {
    color: red;
    content: "*";
}

select {
    width: 100%;
}

table.main {
    display: block;
    float: left;
    height: auto;
    margin: 2px 0 0 0;
}

.main td, .main tr, .main tbody  {
    display: block;
    float: left;
    clear: both;
    height: auto;
    width: 100%;
    margin: 0;
    padding: 0;
}

.main tr {
    padding: .15em .05em;
    float: left;
}

#emailinfo {
    font-size: .7em;
    padding-top: 0;
    color: #666;
}

tr.emailOptIn, tr.privatePolicy {
    padding-top: 3px;
}

tr.emailOptIn label, tr.privatePolicy label, tr.emailOptIn input, tr.privatePolicy input {
    float: left;
    clear: none;
}

#prechatForm #sWebEmailOptIn, #prechatForm #sPrivatePolicy {
    width: 20px !important;
    padding-top: 0;
    padding-bottom: 0;
    margin-top: 1px;
    border: none;
}

tr.emailOptIn label:not(.inputError), tr.privatePolicy a:not(.inputError) {
    color: #656568;
}

td > label {
    padding-bottom: .2em !important;
    margin-bottom: 0px;
    font-size: .73em;
    color: #333;
    font-weight: 100;
}

#prechatForm button {
    font-weight: 100;
    text-transform: uppercase;
    font-size: .8em;
    display: inline-block;
    padding: .6em 1em;
    color: white;
    text-align: center;
    background: #42b4e6;
    border: 0;
    border-radius: 3px;
    cursor: pointer;
    margin: .6em;
}

#disclaimer {
    font-size: .7em;
    color: #e7e6e6;
    text-decoration: underline;
    padding-top: 10px;
    display: none;
}

.optgroup-header {
    font-weight: bold;
    border-top: 1px solid #f0f0f0;
}

.inputError {
    color: #FF0000 !important;
}

h4#offlineButtonAlert {
    display: block;
    margin-bottom: 5px;
    text-align: center;
    color: #777;
    font-size: 0.75em;
}

[id*=routingBlock] {
    display: none;
}

[id*=routingBlock] h3 {
    display: block;
    margin: 10px 0 5px;
}

input#search {
    border-color: #ddd;
    font-size: .85em;
    height: 24px;
    border-radius: 1px;
    padding-top: 0;
    padding-bottom: 0;
}

input#search + span {
    padding-right: 15px;
}

#livechat .glyphicon {
    font-size: .85em;
}

#livechat .form-control-feedback {
    width: 24px;
    height: 24px;
    line-height: 24px;
}


[id*=routingBlock] a {
    color: #3b8ed5; /*#015ba7;*/
    font-weight: 600;
}
[id*=routingBlock] a:hover {
    color: #45a6f8; /*#23527c;*/
}

[id*=routingTable] {
    table-layout: fixed;
    width: 85%;
    margin: 5px auto 0
}

[id*=routingTable] tr {
    border: 3px solid white;
}

[id*=routingTable] td {
    width: 100%;
    position: relative;
}

[id*=routingTable] td span:first-child {
    float:left;
}

[id*=routingTable] td span:nth-child(2) {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    padding: 0px 10px 0px 10px;
    font-size: .85em;
}

[id*=routingTable] a {
    width: 100px;
    height: 100px;
    border-radius: 50px;
    color:#fff;
    text-align: center;
    text-decoration: none;
    background: #42b4e6;
    display: table-cell;
    vertical-align: middle;
    font-weight: 500;
}

[id*=routingTable] a:hover {
    color: #fff;
    text-decoration: none;
    background: #42c7e6;
}

[id*=routingTable] div {
    width: 100px;
    height: 100px;
    border-radius: 50px;
    color: #fff;
    text-align: center;
    text-decoration: none;
    background: #aaa;
    display: table-cell;
    vertical-align: middle;
}

.panel-group {
    margin: 5px auto 0;
}

li span {
    color: #949494; /*#777;*/
}

.panel-group .panel-heading {
    padding: 0;
    background-color: #333;
    border-color: #333;
    border-radius: 1px;
}

.panel-default {
    border: 0;
}

.panel-title a {
    color: #fff;
    display: block;
    width: 100%;
    padding: 10px 15px;
    font-weight: 500;
}

.panel-title a:hover {
    text-decoration: none;
    color: #fff;
}

/* Icon when the collapsible content is shown */
.panel-title a:after {
    font-family: "Glyphicons Halflings";
    content: "\e260"; /*"\e113";*/
    float: right;
    margin-left: 15px;
}

/* Icon when the collapsible content is hidden */
.panel-title a.collapsed:after {
    content: "\e259"; /*"\e114";*/
}

.panel-collapse {
    border-bottom: 1px solid #ddd;
    border-left: 1px solid #ddd;
    border-right: 1px solid #ddd;
}

#livechat .list-group {
    border-top: 0;
}

.list-group-item {
    font-size: 0.85em !important;
}

/* Icon for available choices */
.list-group-item a:after {
    font-family: "Glyphicons Halflings";
    content: "\e080"; /*"\e258";*/
    float: right;
    margin-left: 15px;
}