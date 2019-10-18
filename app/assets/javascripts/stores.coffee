@updateMessageView = ->
	if $('.chat-dlg #messages').length
		msgContent = $('.chat-dlg #messages')[0]
		msgContent.scrollTop = msgContent.scrollHeight
		$('.msg-field textarea').val('')
		$("#message_isPayURL").val(false)
	return

refreshKeyPressed = false
modifierPressed = false
f5key = 116
rkey = 82
modkey = [17,224,91,93]

$(document).bind 'keydown', (evt) ->
	if evt.which == f5key or modifierPressed and evt.which == rkey
		refreshKeyPressed = true
	if modkey.indexOf(evt.which) >= 0
		modifierPressed = true
	return

$(document).bind 'keyup', (evt) ->
	if evt.which == f5key or evt.which == rkey
		refreshKeyPressed = false
	if modkey.indexOf(evt.which) >= 0
		modifierPressed = false
	return

$(window).bind 'beforeunload', (event) ->
	if $('#messages.user').length && refreshKeyPressed == false
		Rails.ajax
			url: '/stores/userout'
			type: 'post'
			data: ''
			success: (data) ->
				return
			error: (data) ->
				return
	return

# $(window).bind 'unload', (event) ->
# 	if $('#messages.user').length
# 		console.log "unload"
# 	return

$(document).on 'turbolinks:load',  ->
	open_msg_dlg = ->
		return
	close_msg_dlg = ->
		return
	$('#dialog-confirm').dialog
		autoOpen: false
		resizable: false
		height: 'auto'
		width: 300
		modal: true
		buttons:
			'はい': ->
				$(this).dialog 'close'
				open_msg_dlg()
				return
			'いいえ': ->
				$(this).dialog 'close'
				close_msg_dlg()
				return
	if $('.chat-dlg #messages').length
		if gon.chatEnabled == true
			if gon.defaultEnable == true
				open_msg_dlg()
			else
				$( "#dialog-confirm" ).dialog( "open" )

			$('.chat-dlg').on 'click', '.title', ->
				console.log($('.chat-dlg').height())
				if $('.chat-dlg').height() < 100
					open_msg_dlg()
				else
					close_msg_dlg()
				return

	$('.item-select-form').on 'click', '.item-select', (e) ->
		itemUrl = $(".items .field input[type='radio']:checked ~ input[type='hidden']").val()
		$("#message_isPayURL").val(true)
		$('.msg-field textarea').val(itemUrl)
		e.preventDefault()
		return

	$(document).on 'click', '.remove_btn_admin_site', (e) ->
		$(this).parent().closest('.site').remove()
		e.preventDefault()
		return

	$(document).on 'click', '.remove_btn_store_stuff', (e) ->
		$(this).parent().closest('.stuff_item').remove()
		e.preventDefault()
		return

	$(document).on 'click', '.remove_btn_store_item', (e) ->
		$(this).parent().closest('.store_item').remove()
		e.preventDefault()
		return
