codeunit 65901 "O4N Azure Table API"
{
    procedure QueryTables(AccountName: Text; AccessKey: Text) Xml: XmlDocument
    var
        PathTok: Label '/%1/Tables',Locked = true;
        WebRequest: HttpRequestMessage;
        WebResponse: HttpResponseMessage;
        WebContent: HttpContent;
        WebHeaders: HttpHeaders;
        WebClient: HttpClient;
        CanonicalizedResource: Text;
        Authorization: Text;
        ResponseXml: Text;
    begin
        Initialize(AccountName);
        CanonicalizedResource := StrSubstNo(PathTok, AccountName);
        Authorization := APIHelper.GetAuthorization(AccountName, AccessKey, APIHelper.GetTextToHash(UTCDateTimeText, CanonicalizedResource));

        WebRequest.SetRequestUri(StorageAccountUrl + 'Tables');
        WebRequest.Method('GET');
        WebRequest.GetHeaders(WebHeaders);
        WebHeaders.Add('Authorization', Authorization);
        WebHeaders.Add('Date', UTCDateTimeText);
        WebClient.Send(WebRequest, WebResponse);
        if not WebResponse.IsSuccessStatusCode then
            Error(FailedToVerifyTableAccessErr, WebResponse.ReasonPhrase);
        WebContent := WebResponse.Content;
        WebContent.ReadAs(ResponseXml);
        XmlDocument.ReadFrom(ResponseXml, Xml);
    end;

    procedure QueryTables(AccountName: Text; AccessKey: Text; var Buffer: Record "Name/Value Buffer")
    var
        TableNodeList: XmlNodeList;
        TableNode: XmlNode;
        Xml: XmlDocument;

    begin
        if not Buffer.IsTemporary() then
            Error(RecordNotTemporaryErr, Buffer.TableCaption);
        Buffer.DeleteAll();

        Xml := QueryTables(AccountName, AccessKey);
        if not Xml.SelectNodes('//*[local-name()="TableName"]', TableNodeList) then exit;
        foreach TableNode in TableNodeList do
            Buffer.AddNewEntry(CopyStr(TableNode.AsXmlElement().InnerText(), 1, MaxStrLen(Buffer.Name)), '');
    end;

    procedure QueryEntities(AccountName: Text; TableName: Text; AccessKey: Text) Xml: XmlDocument
    var
        PathTok: Label '/%1/%2', Locked = true;
        WebRequest: HttpRequestMessage;
        WebResponse: HttpResponseMessage;
        WebContent: HttpContent;
        WebHeaders: HttpHeaders;
        WebClient: HttpClient;
        CanonicalizedResource: Text;
        Authorization: Text;
        ResponseXml: Text;
    begin
        Initialize(AccountName);
        CanonicalizedResource := StrSubstNo(PathTok, AccountName, TableName);
        Authorization := APIHelper.GetAuthorization(AccountName, AccessKey, APIHelper.GetTextToHash(UTCDateTimeText, CanonicalizedResource));

        WebRequest.SetRequestUri(StorageAccountUrl + TableName);
        WebRequest.Method('GET');
        WebRequest.GetHeaders(WebHeaders);
        WebHeaders.Add('Authorization', Authorization);
        WebHeaders.Add('Date', UTCDateTimeText);
        WebClient.Send(WebRequest, WebResponse);
        if not WebResponse.IsSuccessStatusCode then
            Error(FailedToVerifyTableAccessErr, WebResponse.ReasonPhrase);
        WebContent := WebResponse.Content;
        WebContent.ReadAs(ResponseXml);
        XmlDocument.ReadFrom(ResponseXml, Xml);
    end;

    procedure QueryEntities(AccountName: Text; TableName: Text; AccessKey: Text; var Buffer: Record "O4N Azure Table Entity")
    var
        EntityNodeList: XmlNodeList;
        EntityNode: XmlNode;
        Xml: XmlDocument;
    begin
        if not Buffer.IsTemporary() then
            Error(RecordNotTemporaryErr, Buffer.TableCaption);
        Buffer.DeleteAll();

        Xml := QueryEntities(AccountName, TableName, AccessKey);
        if not Xml.SelectNodes('//*[local-name()="entry"]', EntityNodeList) then exit;
        foreach EntityNode in EntityNodeList do
            Buffer.ImportXml(EntityNode);
    end;

    local procedure Initialize(AccountName: Text)
    begin
        UTCDateTimeText := APIHelper.GetUTCDateTimeText();
        StorageAccountUrl := 'https://' + AccountName + '.table.core.windows.net/';
    end;

    var
        APIHelper: Codeunit "O4N Azure Table API Helper";
        FailedToVerifyTableAccessErr: Label 'Failed to verify table access: %1', Comment = '%1 = Reason Phrase';
        RecordNotTemporaryErr: Label 'Table %1 can only be used as a temporary storage!', Comment = '%1 = Table Name';
        UTCDateTimeText: Text;
        StorageAccountUrl: Text;

}
