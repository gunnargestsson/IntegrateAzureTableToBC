table 65901 "O4N Azure Table Entity"
{
    Caption = 'Azure Table Entity';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Partition Key"; Code[20])
        {
            Caption = 'Partition Key';
            DataClassification = SystemMetadata;
        }
        field(20; "Row Key"; Code[200])
        {
            Caption = 'Row Key';
            DataClassification = SystemMetadata;
        }
        field(30; "Time Stamp"; DateTime)
        {
            Caption = 'Time Stamp';
            DataClassification = CustomerContent;
        }
        field(40; "Product Id"; Text[100])
        {
            Caption = 'Product Id';
            DataClassification = CustomerContent;
        }
        field(50; "First Name"; Text[100])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }
        field(60; "Last Name"; Text[100])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
        }
        field(70; "E-Mail"; Text[100])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        }
        field(80; Phone; Text[50])
        {
            Caption = 'Phone';
            DataClassification = CustomerContent;
        }
        field(90; Country; Text[50])
        {
            Caption = 'Country';
            DataClassification = CustomerContent;
        }
        field(100; Company; Text[100])
        {
            Caption = 'Company';
            DataClassification = CustomerContent;
        }
        field(110; Title; Text[100])
        {
            Caption = 'Title';
            DataClassification = CustomerContent;
        }
        field(120; "Lead Source"; Text[100])
        {
            Caption = 'Lead Source';
            DataClassification = CustomerContent;
        }
        field(130; "Action Code"; Code[10])
        {
            Caption = 'Action Code';
            DataClassification = CustomerContent;
        }
        field(140; "Publisher Display Name"; Text[100])
        {
            Caption = 'Publisher Display Name';
            DataClassification = CustomerContent;
        }
        field(150; "Offer Display Name"; Text[100])
        {
            Caption = 'Offer Display Name';
            DataClassification = CustomerContent;
        }
        field(160; "Created Time"; DateTime)
        {
            Caption = 'Created Time';
            DataClassification = CustomerContent;
        }
        field(170; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Partition Key", "Row Key")
        {
            Clustered = true;
        }
        key(DateTimeKey; "Time Stamp")
        {

        }
    }

    procedure ImportXml(EntityNode: XmlNode)
    var
        TypeHelper: Codeunit "Type Helper";
        ContentNode: XmlNode;
        PropertiesNode: XmlNode;
        PropertyNode: XmlNode;
        JObject: JsonObject;
        JToken: JsonToken;
        DateTimeVariant: Variant;
    begin
        if not EntityNode.SelectSingleNode('./*[local-name()="content"]', ContentNode) then exit;
        if not ContentNode.SelectSingleNode('./*[local-name()="properties"]', PropertiesNode) then exit;
        Rec.Init();
        if PropertiesNode.SelectSingleNode('./*[local-name()="PartitionKey"]', PropertyNode) then
            Rec."Partition Key" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Partition Key"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="RowKey"]', PropertyNode) then
            Rec."Row Key" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Row Key"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="Timestamp"]', PropertyNode) then
            Evaluate(Rec."Time Stamp", PropertyNode.AsXmlElement().InnerText, 9);
        if PropertiesNode.SelectSingleNode('./*[local-name()="ProductId"]', PropertyNode) then
            Rec."Product Id" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Product Id"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="LeadSource"]', PropertyNode) then
            Rec."Lead Source" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Lead Source"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="ActionCode"]', PropertyNode) then
            Rec."Action Code" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Action Code"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="PublisherDisplayName"]', PropertyNode) then
            Rec."Publisher Display Name" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Publisher Display Name"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="OfferDisplayName"]', PropertyNode) then
            Rec."Offer Display Name" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Offer Display Name"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="CreatedTime"]', PropertyNode) then begin
            DateTimeVariant := Rec."Created Time";
            if TypeHelper.Evaluate(DateTimeVariant, PropertyNode.AsXmlElement().InnerText, 'MM/dd/yyyy HH:mm:ss', 'en-US') then
                Rec."Created Time" := DateTimeVariant;
        end;
        if PropertiesNode.SelectSingleNode('./*[local-name()="Description"]', PropertyNode) then
            Rec."Description" := CopyStr(PropertyNode.AsXmlElement().InnerText, 1, MaxStrLen(Rec."Description"));
        if PropertiesNode.SelectSingleNode('./*[local-name()="CustomerInfo"]', PropertyNode) then
            if JObject.ReadFrom(PropertyNode.AsXmlElement().InnerText) then begin
                if JObject.Get('FirstName', JToken) then
                    if not JToken.AsValue().IsNull then
                        Rec."First Name" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(Rec."First Name"));
                if JObject.Get('LastName', JToken) then
                    if not JToken.AsValue().IsNull then
                        Rec."Last Name" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(Rec."Last Name"));
                if JObject.Get('Email', JToken) then
                    if not JToken.AsValue().IsNull then
                        Rec."E-Mail" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(Rec."E-Mail"));
                if JObject.Get('Phone', JToken) then
                    if not JToken.AsValue().IsNull then
                        Rec."Phone" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(Rec."Phone"));
                if JObject.Get('Country', JToken) then
                    if not JToken.AsValue().IsNull then
                        Rec."Country" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(Rec."Country"));
                if JObject.Get('Company', JToken) then
                    if not JToken.AsValue().IsNull then
                        Rec."Company" := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(Rec."Company"));
                if JObject.Get('Title', JToken) then
                    if not JToken.AsValue().IsNull then
                        Rec.Title := CopyStr(JToken.AsValue().AsText(), 1, MaxStrLen(Rec.Title));
            end;
        Rec.Insert();
    end;

}
