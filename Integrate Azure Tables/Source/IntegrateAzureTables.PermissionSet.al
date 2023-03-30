permissionset 65900 IntegrateAzureTables
{
    Assignable = true;
    Caption = 'Integrate Azure Tables', MaxLength = 30;
    Permissions =
        table "O4N Azure Table Entity" = X,
        tabledata "O4N Azure Table Entity" = RMID,
        table "O4N Azure Table Setup" = X,
        tabledata "O4N Azure Table Setup" = RMID,
        codeunit "O4N Azure Table Job Queue" = X,
        codeunit "O4N Azure Table API Helper" = X,
        codeunit "O4N Azure Table API" = X,
        page "O4N Azure Table Setup" = X,
        page "O4N Azure Table List" = X,
        page "O4N Azure Table Entities" = X;
}
