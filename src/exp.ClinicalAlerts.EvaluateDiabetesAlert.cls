/// 
Class exp.ClinicalAlerts.EvaluateDiabetesAlert Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="exp.ClinicalAlerts.DiabetesAlertProcess.Context" production="">
<ruleSet name="Diabetes Alert Rule Set" effectiveBegin="" effectiveEnd="">
<rule name="Normal Priority Diabetes Statin Rule" disabled="false">
<when condition="Not(ruleRequest.IsOnStatin)&amp;&amp;ruleRequest.IsDiabetic&amp;&amp;(ruleRequest.LDL&gt;100)&amp;&amp;(ruleRequest.LDL&lt;=150)">
<return>"Send Diabetes Alert"</return>
</when>
<otherwise>
<return>"Send No Alert"</return>
</otherwise>
</rule>
<rule name="Critical Priority Diabetes Statin Rule" disabled="false">
<when condition="Not(ruleRequest.IsOnStatin)&amp;&amp;ruleRequest.IsDiabetic&amp;&amp;(ruleRequest.LDL&gt;150)">
<return>"Send Critical Diabetes Statin Alert"</return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}

