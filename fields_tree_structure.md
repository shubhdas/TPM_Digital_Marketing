# Salesforce Digital Marketing CRM - Fields Tree Structure

## 1. Lead Object (Standard)
- CompanyName__c (Text)
- ContactPersonName__c (Text)
- EmailAddress__c (Email)
- PhoneNumber__c (Phone)
- Status__c (Picklist)
- Source__c (Picklist)
- Industry__c (Picklist)
- BudgetRange__c (Currency)
- LeadScore__c (Number)
- Notes__c (Long Text Area)

## 2. CustomLead__c (Custom)
- CompanyName__c (Text)
- ContactPersonName__c (Text)
- EmailAddress__c (Email)
- PhoneNumber__c (Phone)
- Status__c (Picklist)
- Source__c (Picklist)
- Industry__c (Picklist)
- BudgetRange__c (Currency)
- LeadScore__c (Number)
- Notes__c (Long Text Area)

## 3. Campaign__c (Custom)
- Name (Text) - System field
- Status__c (Picklist)
- Budget__c (Currency)
- Billing__c (Lookup to Billing__c)
- Description__c (Long Text Area)
- Start_Date__c (Date)
- End_Date__c (Date)

## 4. Project__c (Custom)
- Name (Text) - System field
- Status__c (Picklist)
- Budget__c (Currency)
- Campaign__c (Lookup to Campaign__c)
- Description__c (Long Text Area)
- Start_Date__c (Date)
- End_Date__c (Date)

## 5. Billing__c (Custom)
- Name (Text) - System field
- Amount__c (Currency)
- Billing_Date__c (Date)
- Client__c (Lookup to Client__c)
- Status__c (Picklist)

## 6. Client__c (Custom)
- Name (Text) - System field
- Client_Address__c (Text Area)
- Client_Email__c (Email)
- Client_Phone__c (Phone)
- Client_Status__c (Picklist)

## Relationships
- Campaign__c.Billing__c → Billing__c.Id
- Project__c.Campaign__c → Campaign__c.Id
- Billing__c.Client__c → Client__c.Id
