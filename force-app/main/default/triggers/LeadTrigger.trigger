trigger LeadTrigger on Lead (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for (Lead l : Trigger.new) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { 'manager@example.com' }); // Change to your recipient
        mail.setSubject('New Lead Created: ' + l.Name);
        mail.setPlainTextBody('A new lead has been created with the name: ' + l.Name);
        emails.add(mail);
    }
    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}