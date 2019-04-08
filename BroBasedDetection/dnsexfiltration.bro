module dns;

export {
    #The notice
    redef enum Notice::Type += { 
	DNS::Exfiltration,
	};
    #Create the log
    redef enum Log::ID += { 
	LOG 
	};
}
#Function to raise the notice
function dnsExfiltration (c: connection, query: string){
    NOTICE([ $note = DNS::Exfiltration, 
	     $msg = fmt("Long Domain. Possible DNS exfiltration/tunnel by %s. Offending domain name: %s", c$id$orig_h, query)]);
}
#The event to raise the notice
event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count){
    if(|query| > 52){
        dnsExfiltration(c, query);
    }
}
