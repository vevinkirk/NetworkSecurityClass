module Mqtt;

export{
	#Notice to be raised
	redef enum Notice::Type += {
		Mqtt::Subscribe
	};
	#Log Creation
	redef enum Log::ID += {
		LOG
	};
	#Ignoring the checksum warning in the output
	redef ignore_checksums = T;
	#manually create the records
	type Info: record {
		ts: time &log;
		src_ip: addr &log;
		src_port: port &log;
		dst_ip: addr &log;
		dst_port: port &log;
		length: count &log;
		payload: string &log;
	};	
}

#Function to create Mqtt log
function writeToLog (c: connection, topic: string) {
        local rec: Mqtt::Info = [
                $ts = network_time(),
                $src_ip = c$id$orig_h,
                $src_port = c$id$orig_p,
                $dst_ip = c$id$resp_h,
                $dst_port = c$id$resp_p,
                $length = 0,
                $payload = topic];
        Log::write(Mqtt::LOG, rec);
}


#Checks for the beginning of Mqtt package of 82
function checkMessageSubscribe(message: string,c: connection): bool{
	if(sub_bytes(message,1,2) == "82"){
		local topic = hexstr_to_bytestring(sub_bytes(message,13,|message|-14));
		writeToLog(c,topic);
		if("#" in topic){
			return T;
		}
	}
	return F;
}

#Raise notice for Mqtt packet
function subscribeAlert(c:connection){
	NOTICE([ $note = Mqtt::Subscribe, $msg = fmt("%s attempts to subscribe to all topics",c$id$orig_h)]);	
}

#function that does all the work and looks at packet contents for the event
event packet_contents (c: connection, contents: string) {
  if (c$id$resp_p == 1883/tcp) {
		local messageLength: count;
		local messageStart: string;
		local messageTrim: string;
		local messageFull = string_to_ascii_hex(contents);
		while(messageFull != ""){
			messageLength = bytestring_to_count(hexstr_to_bytestring(sub_bytes(messageFull,3,2))); #get first message
			messageLength = (messageLength + 2)*2;
			messageStart = sub_bytes(messageFull,1,messageLength);
			messageFull = subst_string(messageFull, messageStart, "");
			if(checkMessageSubscribe(messageStart,c)){
				subscribeAlert(c);
			}
		}
  }
 }

#Priority higher than 0 to allow changing in other scripts
event bro_init() &priority=5{
        Log::create_stream(Mqtt::LOG, [$columns=Info, $path="mqtt"]);
}


