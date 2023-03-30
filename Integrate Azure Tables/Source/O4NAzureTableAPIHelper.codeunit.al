codeunit 65902 "O4N Azure Table API Helper"
{
    procedure GetUTCDateTimeText(): Text
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        exit(TypeHelper.GetCurrUTCDateTimeAsText());
    end;

    procedure ParseUTCDateTimeText(DateTimeText: Text) UTCDate: DateTime
    var
        TypeHelper: Codeunit "Type Helper";
        DateVariant: Variant;
    begin
        DateVariant := CurrentDateTime();
        if not TypeHelper.Evaluate(DateVariant, DateTimeText, 'R', '') then exit;
        UTCDate := DateVariant;
    end;

    procedure GetTextToHash(UTCDateTimeText: Text; CanonicalizedResource: Text) TextToHash: Text
    var
        NewLine: Text[1];
    begin
        NewLine[1] := 10;
        exit(UTCDateTimeText + NewLine + CanonicalizedResource);
    end;

    procedure GetAuthorization(AccountName: Text; HashKey: Text; TextToHash: Text) Authorization: Text;
    begin
        Authorization := 'SharedKeyLite ' + AccountName + ':' + GenerateKeyedHash(TextToHash, HashKey);
    end;

    local procedure GenerateKeyedHash(TextToHash: Text; HashKey: Text) KeyedHash: Text
    var
        EncryptionMgt: Codeunit "Cryptography Management";
        HashAlgorithmType: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512;
    begin
        KeyedHash := EncryptionMgt.GenerateBase64KeyedHashAsBase64String(TextToHash, HashKey, HashAlgorithmType::HMACSHA256)
    end;

}
