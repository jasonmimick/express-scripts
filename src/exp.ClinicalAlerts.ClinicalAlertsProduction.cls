Class exp.ClinicalAlerts.ClinicalAlertsProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="exp.ClinicalAlerts.ClinicalAlertsProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Inbound HL7" Category="" ClassName="EnsLib.HL7.Service.HTTPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Drug Disease Process</Setting>
    <Setting Target="Adapter" Name="Port">9980</Setting>
    <Setting Target="Host" Name="AckMode">Immed</Setting>
  </Item>
  <Item Name="exp.ClinicalAlerts.DiabetesAlertProcess" Category="" ClassName="exp.ClinicalAlerts.DiabetesAlertProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Inbound Omission Fax" Category="" ClassName="EnsLib.HTTP.GenericService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">9995</Setting>
    <Setting Target="Host" Name="TargetConfigName">exp.ClinicalAlerts.OmissionOfTherapyProcess</Setting>
  </Item>
  <Item Name="Omission Of Therapy Process" Category="" ClassName="exp.ClinicalAlerts.OmissionOfTherapyProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="HL7ToSDAProcess" Category="" ClassName="exp.ClinicalAlerts.HL7ToSDAProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Alert Response Receiver" Category="" ClassName="EnsLib.HTTP.GenericService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">Alert Response Processor</Setting>
    <Setting Target="Adapter" Name="Port">9989</Setting>
  </Item>
  <Item Name="Alert Response Processor" Category="" ClassName="exp.ClinicalAlerts.ResponseOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Drug Disease Process" Category="" ClassName="exp.ClinicalAlerts.DrugDiseaseAlertProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="Email Operation" Category="" ClassName="exp.ClinicalAlerts.EmailOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">HealthShareAlertsGMail</Setting>
    <Setting Target="Adapter" Name="SMTPPort">465</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.gmail.com</Setting>
    <Setting Target="Adapter" Name="SSLConfig">FOO</Setting>
    <Setting Target="Adapter" Name="From">HealthShareAlerts</Setting>
  </Item>
</Production>
}

}

