App.messages = App.cable.subscriptions.create('MessagesChannel', {  
	received: function(data) {
		if (data.message) {
			if (data.roomId + '' == $('#message_chat_room_id').val()) {
				$('#messages').append(this.renderMessage(data));
				updateMessageView();
			}
		}
		this.renderUserStatus(data);
		return
	},

	renderMessage: function(data) {
		msg = "<span class='msg'>" + data.message + "</span>";
		if (data.isPayURL == true) {
			msg = "<a class='pay' href='" + data.message + "'>決済ページへ</a>"
		}
		toUserMsg = "<div class='right'>" + msg + "</div>";
		toAdminMsg = "<div class='left'>" + msg + "</div>";
		return data.toUser == true ? toUserMsg : toAdminMsg
	},

	renderUserStatus: function(data) {
		if(data.user_site_ids) {
			cnt = 0;
			for (var i of data.user_site_ids) {
				for (var j of data.site_ids ) {
					// console.log(i, j)
					if (i == j) {
						cnt ++;
						break;
					}
				}
			}
			// console.log(data)
			console.log(cnt)
			if ($('.store-accessing-user-cnt').length) {
				$('.store-accessing-user-cnt').text(cnt);
				$('.store-accessing-top-user-cnt').text(cnt);
				$('.store-accessing-item-user-cnt').text(cnt - cnt);
			}
		}
	}
});
