<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_WFU_Test</fullName>
        <field>Name</field>
        <formula>&quot;TestTestTest&quot;</formula>
        <name>Account WFU Test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FIeldUpdate1</fullName>
        <field>AccountSource</field>
        <literalValue>Phone Inquiry</literalValue>
        <name>FIeldUpdate1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AccountWFR Test</fullName>
        <actions>
            <name>Account_WFU_Test</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FIeldUpdate1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
