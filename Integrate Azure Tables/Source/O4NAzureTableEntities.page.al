page 65902 "O4N Azure Table Entities"
{

    ApplicationArea = All;
    Caption = 'Azure Table Entities';
    PageType = List;
    SourceTable = "O4N Azure Table Entity";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Partition Key"; Rec."Partition Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Partition Key field';
                    Visible = false;
                }
                field("Row Key"; Rec."Row Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Row Key field';
                    Visible = false;
                }
                field("Time Stamp"; Rec."Time Stamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Stamp field';
                    Visible = false;
                }
                field("Product Id"; Rec."Product Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Id field';
                    Visible = false;
                }
                field("Customer First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer First Name field';
                }
                field("Customer Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Last Name field';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-Mail field';
                }
                field(Phone; Rec.Phone)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone field';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country field';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company field';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field';
                }
                field("Lead Source"; Rec."Lead Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lead Source field';
                    Visible = false;
                }
                field("Action Code"; Rec."Action Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action Code field';
                }
                field("Publisher Display Name"; Rec."Publisher Display Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Publisher Display Name field';
                }
                field("Offer Display Name"; Rec."Offer Display Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Offer Display Name field';
                }
                field("Created Time"; Rec."Created Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created Time field';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                    Visible = false;
                }
            }
        }
    }

}
