App.messages = App.cable.subscriptions.create('MessagesChannel', {  
	received: function(data) {
		if (data.message) {
			if (data.roomId + '' == $('#message_chat_room_id').val()) {
				$('#messages ul').append(this.renderMessage(data));
				updateMessageView();
			}
		}
		this.renderUserStatus(data);
		return
	},

	renderMessage: function(data) {
		msg = "<h4 class='timeline-title'>" + data.message + "</h4>";
		if (data.isPayURL == true) {
			msg = "<a class='btn btn-primary' href='" + data.message + "'>決済ページへ</a>"
		}
		toUserMsg = "<li class='timeline-inverted'><div class='timeline-panel'><div class='timeline-heading'>" + msg + "</div></div></li>";
		toAdminMsg = "<li class='timeline'><div class='timeline-panel'><div class='timeline-heading'>" + msg + "</div></div></li>";
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
