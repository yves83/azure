# Redirect Windows Forwared Event to SecurityEvent Table in Log Aanalytic Workspace

Background
Windows Event Forwarder collect the remote Windows Event logs and saved in Forwared Event table. Sentinel collect the Forwared Event logs with Windows Forwared Event data connector.
However, the Windows Events are saved in WindowsEvent table of Log Analytic Workspace. To redirect the Windows Security log to SecurityEvent table, we must use DCR transform rule to 
migrate the data from WindowsEvent to SecurityEvent. The most challenging configuration is mapping the fields in WindowsEvent to SecurityEvent. Below is the dataFlows configuration.
Copy the following configuration and replace the DCR configuration in the template.

Partial Data Collection Rule Configuration
=============================================
```
"dataFlows": [
    {
        "streams": [
            "Microsoft-WindowsEvent"
        ],
        "destinations": [
            "DataCollectionEvent"
        ],
        "transformKql": "source | where Channel != 'Security'",
        "outputStream": "Microsoft-WindowsEvent"
    },					
    {
        "streams": [
            "Microsoft-WindowsEvent"
        ],
        "destinations": [
            "DataCollectionEvent"
        ],
        "transformKql": "source | where Channel == 'Security' | extend e=parse_json(EventData) | project AccessList=tostring(e.AccessList), AccessMask=tostring(e.AccessMask), AdditionalInfo=tostring(e.AdditionalInfo), AdditionalInfo2=tostring(e.AdditionalInfo2), AuthenticationPackageName=tostring(e.AuthenticationPackageName), CallerProcessId=tostring(e.CallerProcessId), CallerProcessName=tostring(e.CallerProcessName), CommandLine=tostring(e.CommandLine), ElevatedToken=tostring(e.ElevatedToken), FailureReason=tostring(e.FailureReason), HandleId=tostring(e.HandleId), ImpersonationLevel=tostring(e.ImpersonationLevel), IpAddress=tostring(e.IpAddress), IpPort=tostring(e.IpPort), KeyLength=toint(e.KeyLength), LmPackageName=tostring(e.LmPackageName), LogonGuid=toguid(e.LogonGuid), LogonProcessName=tostring(e.LogonProcessName), LogonType=toint(e.LogonType), MandatoryLabel=tostring(e.MandatoryLabel), NewProcessId=tostring(e.NewProcessId), NewProcessName=tostring(e.NewProcessName), ObjectName=tostring(e.ObjectName), ObjectServer=tostring(e.ObjectServer), ObjectType=tostring(e.ObjectType), OperationType=tostring(e.OperationType), ParentProcessName=tostring(e.ParentProcessName), PrivilegeList=tostring(e.PrivilegeList), ProcessId=tostring(e.ProcessId), ProcessName=tostring(e.ProcessName), Properties=tostring(e.Properties), RestrictedAdminMode=tostring(e.RestrictedAdminMode), SamAccountName=tostring(e.SamAccountName), ServiceAccount=tostring(e.ServiceAccount), ServiceFileName=tostring(e.ServiceFileName), ServiceName=tostring(e.ServiceName), ServiceStartType=toint(e.ServiceStartType), ServiceType=tostring(e.ServiceType), SidHistory=tostring(e.SidHistory), Status=tostring(e.Status), SubjectDomainName=tostring(e.SubjectDomainName), SubjectLogonId=tostring(e.SubjectLogonId), SubjectUserName=tostring(e.SubjectUserName), SubjectUserSid=tostring(e.SubjectUserSid), SubStatus=tostring(e.SubStatus), TargetDomainName=tostring(e.TargetDomainName), TargetInfo=tostring(e.TargetInfo), TargetLinkedLogonId=tostring(e.TargetLinkedLogonId), TargetLogonGuid=toguid(e.TargetLogonGuid), TargetLogonId=tostring(e.TargetLogonId), TargetOutboundDomainName=tostring(e.TargetOutboundDomainName), TargetOutboundUserName=tostring(e.TargetOutboundUserName), TargetServerName=tostring(e.TargetServerName), TargetSid=tostring(e.TargetSid), TargetUserName=tostring(e.TargetUserName), TargetUserSid=tostring(e.TargetUserSid), TokenElevationType=tostring(e.TokenElevationType), TransmittedServices=tostring(e.TransmittedServices), VirtualAccount=tostring(e.VirtualAccount), WorkstationName=tostring(e.WorkstationName), Channel=tostring(Channel), Computer=tostring(Computer), EventID=toint(EventID), EventOriginId=tostring(EventOriginId), Account=iif(isempty(e.TargetUserName) or e.TargetUserName =='-', '', strcat(e.TargetDomainName,'\\',e.TargetUserName)), EventSourceName=tostring(Provider), Level=tostring(EventLevel), SubjectAccount=iif(isempty(e.SubjectUserName) or e.SubjectUserName =='-', '', strcat(e.SubjectDomainName,'\\',e.SubjectUserName)), TargetAccount=iif(isempty(e.TargetUserName) or e.TargetUserName =='-', '', strcat(e.TargetDomainName,'\\',e.TargetUserName)), Type='SecurityEvent'",
        "outputStream": "Microsoft-SecurityEvent"
    }
]
```
