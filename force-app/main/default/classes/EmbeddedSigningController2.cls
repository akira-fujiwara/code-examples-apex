public class EmbeddedSigningController2 {
    /**
 *  sendEnvelope method (String)
 *    Get Salesforce user ID
 *    Create an envelope
 *    Specify embedded signing
 *    Add a document template
 *    Send the envelope immediately
 *    Return the envelope ID to the controller as a string
 */

@AuraEnabled
public static String sendEnvelope2(String template, String description, Id recordId, String url) {
    Id mySourceId = recordId; // The ID of the initiating Salesforce object
    system.debug(logginglevel.DEBUG,'---start sendEnvelope2 process ---');
    // Create an empty envelope and add a Salesforce Document and embedded signer  recipient
    // The embedded signer will be the current user with sequence and routing order 1 and role "Signer 1" by default
    dfsle.Envelope dsEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        new dfsle.Entity(mySourceId)) // The initiating Salesforce entity--current SF user (salesperson)
        .withDocuments(new List<dfsle.Document> {
        dfsle.Document.fromTemplate(dfsle.UUID.parse(template), description)
        })
        .withRecipients(new List<dfsle.Recipient> {
        dfsle.Recipient.newEmbeddedSigner() // An embedded signer
        }
    );
    system.debug(logginglevel.DEBUG,'---start sendEnv2--- phase2'); 
    // Send the envelope.
    dsEnvelope = dfsle.EnvelopeService.sendEnvelope(
        dsEnvelope, // The envelope to send
        false // Send now?
    );
    // Return string value of DocuSign envelope ID

    String envId = String.valueOf(dsEnvelope.docuSignId);
    system.debug(logginglevel.DEBUG,'---start sendEnv2--- phase3');
    system.debug(logginglevel.DEBUG,'--- ENVID = ' + envId);
    
    
    Url mySigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
      dfsle.UUID.parse(envId), // envId value as a UUID
      new URL(url) // url value as a URL
    );
    system.debug(logginglevel.DEBUG,'--- Return url = ' + mySigningUrl.toExternalForm()); 
    return mySigningUrl.toExternalForm();
}


/**
 *  getEmbeddedSigningUrl method (String)
 *    Get the envelope ID
 *    Get the post-signing URL
 *    Generate an embedded signing URL
 *    Return the embedded signing URL as a string
 */
  
  @AuraEnabled
  public static String getEmbeddedSigningUrl2(String envId, String url) {
    Url mySigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
      dfsle.UUID.parse(envId), // envId value as a UUID
      new URL(url) // url value as a URL
    );
    // Return string value of Url to controller
    return mySigningUrl.toExternalForm();
  }
}