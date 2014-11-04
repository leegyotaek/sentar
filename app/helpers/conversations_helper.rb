module ConversationsHelper




def participants_name(conversation)

 name = []
 participants = conversation.participants
 participants.delete(current_user)
 if participants.count > 3 
 name = (1..3).map {|i| (participants[i]).name }
 name.join(",") + ", ..." #"외 #{participants.count - 3} 명"
else
 # participants.each do |user|
 # 	unless current_user?(user)
 # 	name.push(user.name)
 # 	end

 
 name = participants.map {|user| user.name}

name.join(",")
end

end

def who_read_this(message)
   
   receipts = message.receipts.where(mailbox_type: "inbox")
   read_member = []
   receipts.each do |receipt|
   if receipt.is_read?
   	read_member.push(receipt.receiver)

   end
   
   end
   return read_member

end


def count_unread_message_in(conversation)

	receipts = conversation.receipts_for current_user

     count = 0

     receipts.each do |receipt| 
     	if !receipt.is_read?
     		count += 1
     	end
     end
	
	return count

end




end
