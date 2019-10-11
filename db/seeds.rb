AdminUser.create(email: 'admin@example.com', password: 'password')

store = Store.create(auth_id: '12345678', auth_password: 'password', name: 'TEST1')

Site.create(uid: '12345678', name: 'TEST1', password: 'password', url: 'localhost', store_id: store.id)
Site.create(uid: '12345679', name: 'TEST2', password: 'password', url: 'unlocalhost', store_id: store.id)

Html.create(data: "
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>*****
    <meta name='viewport' content='width=device-width, initial-scale=1'>*****
    *****
    <link rel='stylesheet' href='//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css'>*****
    *****
    <script src='https://code.jquery.com/jquery-1.12.4.js'></script>*****
    <script src='https://code.jquery.com/ui/1.12.1/jquery-ui.js'></script>*****
    <script src='https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js'></script>*****
    *****
    <style type='text/css'>*****
      .chat-dlg-macconnect {*****
        position: fixed;*****
        right: 15px;*****
        bottom: 15px;*****
        width: 400px;*****
        height: 70px;*****
        border: 1px solid gray;*****
        border-radius: 15px;*****
      }*****
*****
      .chat-dlg-macconnect .title {*****
        line-height: 60px;*****
        text-align: center;*****
        padding: 0;*****
        margin: 0;*****
        cursor: pointer;*****
        border-bottom: 1px solid;*****
        border-radius: 15px*****
      }*****
*****
      .chat-dlg-macconnect #messages {*****
        height: 360px;*****
        overflow-y: scroll;*****
      }*****
*****
      .chat-dlg-macconnect #messages.user .right {*****
        text-align: right;*****
        padding: 10px;*****
        position: relative;*****
      }*****
*****
      .chat-dlg-macconnect #messages.user .right .time {*****
        right: 10px;*****
      }*****
*****
      .chat-dlg-macconnect #messages.user .left {*****
        text-align: left;*****
        padding: 10px;*****
        position: relative;*****
      }*****
*****
      .chat-dlg-macconnect #messages.user .left .time {*****
        left: 10px;*****
      }*****
*****
      .chat-dlg-macconnect #messages.user a.pay {*****
        padding: 6px 20px;*****
        background: dimgrey;*****
        border-radius: 5px;*****
      }*****
          *****
      .chat-dlg-macconnect #messages.user span.msg {*****
        display: inline-block;*****
        padding: 15px;*****
        border: 1px solid;*****
        border-radius: 15px;*****
      }*****
*****
      .chat-dlg-macconnect #messages.user span.time {*****
        position: absolute;*****
        bottom: -8px;*****
        font-size: 14px;*****
      }*****
*****
      .chat-dlg-macconnect .send-box {*****
        position: absolute;*****
        left: 0;*****
        bottom: 0;*****
        width: calc(100% - 40px);*****
        padding: 15px 20px;*****
        border-top: 1px solid;*****
      }*****
*****
      .chat-dlg-macconnect .send-box .msg-field {*****
        display: flex;*****
        align-items: center;*****
        justify-content: space-between;*****
      }*****
*****
      .chat-dlg-macconnect .send-box .msg-field textarea {*****
        font-size: 15px;*****
        line-height: 20px;*****
        width: 270px;*****
      }*****
*****
      .chat-dlg-macconnect .send-box .msg-field input[type='submit'] {*****
        width: 60px;*****
      }*****
*****
      .hidden {*****
        display: none;*****
      }*****
*****
      @keyframes load {*****
          0%{*****
              opacity: 0.08;*****
      /*         font-size: 10px; */*****
      /*        font-weight: 400; */*****
              filter: blur(5px);*****
              letter-spacing: 3px;*****
              }*****
          100%{*****
      /*         opacity: 1; */*****
      /*         font-size: 12px; */*****
      /*        font-weight:600; */*****
      /*        filter: blur(0); */*****
              }*****
      }*****
*****
      .chat-dlg-macconnect .chat_dlg_animate {*****
        display:flex;*****
        justify-content: center;*****
        align-items: center;*****
        height:100%;*****
        margin: auto;*****
        font-family: Helvetica, sans-serif, Arial;*****
        animation: load 1.2s infinite 0s ease-in-out;*****
        animation-direction: alternate;*****
        text-shadow: 0 0 1px white;*****
      }*****
*****
      @media (max-width: 500px) {*****
        .chat-dlg-macconnect {*****
          width: 90%;*****
          margin-left: 5%;*****
          right: unset;*****
        }*****
*****
        .chat-dlg-macconnect .send-box {*****
          width: calc(100% - 20px);*****
          padding: 10px 10px;*****
        }*****
*****
        .chat-dlg-macconnect .send-box .msg-field textarea {*****
          width: 220px;*****
        }*****
      }*****
    </style>*****
    <script type='application/javascript'>*****
      $(document).ready(function () {*****
        const serverUrl = 'ws://ec2-3-112-213-130.ap-northeast-1.compute.amazonaws.com:3000/cable';*****
        const hostUrl = window.location.host;*****
        var socket = new WebSocket(serverUrl);*****
        var flag = 0;*****
        var dev_token = Cookies.get('dev_token');*****
        var message = '';*****
        var chatEnabled = false;*****
        var defaultEnable = false;*****
        var roomId = 0;*****
*****
        function updateMessageView() {*****
          if ($('.chat-dlg-macconnect #messages').length) {*****
            msgContent = $('.chat-dlg-macconnect #messages')[0];*****
            msgContent.scrollTop = msgContent.scrollHeight;*****
          }*****
        }*****
*****
        const onOpen = (ws, store, code) => evt => { console.log('WS OPEN'); };*****
        const onClose = (ws, store) => evt => {*****
          console.log('WS CLOSE'); *****
        };*****
        const onMessage = (ws, store) => evt => {*****
          let msg = JSON.parse(evt.data);*****
*****
          switch (msg.type) {*****
            case 'confirm_subscription':*****
              break;*****
            case 'welcome':*****
              welcome_socket();*****
              break;*****
            case 'ping':*****
              if (flag == 0) {*****
                send_msg();*****
              } else if (flag == 1) {*****
                send_msg();*****
              }*****
              flag = -1;*****
              break;*****
            default:*****
              if (msg.message != undefined) {*****
                if (msg.message.isFrontEnd == true) {*****
                  return*****
                }*****
                if (roomId != 0 && roomId != msg.message.roomId) {*****
                  return*****
                }*****
                if (msg.message.messages) {*****
                  if (roomId == 0) {*****
                    roomId = msg.message.roomId;*****
                  }*****
                  $('.chat-dlg-macconnect .title').removeClass('chat_dlg_animate');*****
                  $('.chat-dlg-macconnect .title').text('チャット');*****
                  *****
                  var i = 0;*****
                  var len = msg.message.messages.length;*****
*****
                  if (len == 0) {*****
                    const msgContent = msg.message.userIndex < 5 ? 'こんにちは！' : '少々お待ち下さい。';*****
                    $('.chat-dlg-macconnect #messages').append(render_message({message: msgContent, isPayURL: false, toUser: true}));*****
                    updateMessageView();*****
                  } else {*****
                    for (; i < len; ) {*****
                      $('.chat-dlg-macconnect #messages').append(render_message(msg.message.messages[i]));*****
                      i++;            *****
                    }*****
                    updateMessageView();*****
                  }*****
*****
                  chatEnabled = msg.message.chatEnabled;*****
                  defaultEnable = msg.message.defaultEnable;*****
                  process_dialog();*****
                } else {*****
                  $('.chat-dlg-macconnect #messages').append(render_message(msg.message));*****
                  updateMessageView();*****
                }*****
              }*****
              break;*****
          }*****
        };*****
*****
        function welcome_socket() {*****
          const msg = {*****
            command: 'subscribe',*****
            identifier: JSON.stringify({*****
              channel: 'MessagesChannel'*****
            }),*****
            data: JSON.stringify({*****
              action: 'speak',*****
              data: 'CONNECT'*****
            })*****
          };*****
          socket.send(JSON.stringify(msg));*****
        }*****
*****
        function send_msg() {*****
          const msg = {*****
            command: 'message',*****
            identifier: JSON.stringify({*****
              channel: 'MessagesChannel'*****
            }),*****
            data: JSON.stringify({*****
              action: 'speak',*****
              token: dev_token,*****
              data: message,*****
              url: hostUrl,*****
              isFrontEnd: true*****
            })*****
          };*****
          socket.send(JSON.stringify(msg));*****
        }*****
*****
        function send_close() {*****
          const msg = {*****
            command: 'message',*****
            identifier: JSON.stringify({*****
              channel: 'MessagesChannel'*****
            }),*****
            data: JSON.stringify({*****
              action: 'close',*****
              token: dev_token,*****
              url: hostUrl*****
            })*****
          };*****
          socket.send(JSON.stringify(msg));*****
        }*****
*****
        function makeid(length) {*****
           var result           = '';*****
           var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+abcdefghijklmnopqrstuvwxyz0123456789';*****
           var charactersLength = characters.length;*****
           for ( var i = 0; i < length; i++ ) {*****
              result += characters.charAt(Math.floor(Math.random() * charactersLength));*****
           }*****
           return result;*****
        }*****
*****
        function render_message(data) {*****
          msgContent = \"<span class='msg'>\" + data.message + \"</span>\";*****
          if (data.isPayURL == true) {*****
            msgContent = \"<a class='pay' href='\" + data.message + \"'>決済ページへ</a>\";*****
          }*****
          toUserMsg = \"<div class='right'>\" + msgContent + \"</div>\";*****
          toAdminMsg = \"<div class='left'>\" + msgContent + \"</div>\";*****
          return data.toUser == true ? toUserMsg : toAdminMsg;*****
        }*****
*****
        socket.onmessage = onMessage(socket);*****
        socket.onclose = onClose(socket);*****
        socket.onopen = onOpen(socket);*****
*****
        // Cookies.remove('dev_token')*****
*****
        if (dev_token == undefined) {*****
          dev_token = makeid(20);*****
          Cookies.set('dev_token', dev_token, { expires: 365 });*****
        }*****
*****
        $(document).on('click', '#maxconnect_message_button', function(){*****
          message = $('textarea#maxconnect_message').val();*****
          if (message == '') {return}*****
          flag = 1;*****
          $('textarea#maxconnect_message').val('');*****
          $('.chat-dlg-macconnect #messages').append(render_message({message: message, isPayURL: false, toUser: false}));*****
          updateMessageView();*****
        });*****
*****
        function open_msg_dlg() {*****
          $('.chat-dlg-macconnect').animate({*****
            'height': '500px'*****
          }, 700);*****
          setTimeout((function() {*****
            $('.chat-dlg-macconnect .content').removeClass('hidden');*****
            const msgContent = $('.chat-dlg-macconnect #messages')[0];*****
            msgContent.scrollTop = msgContent.scrollHeight;*****
          }), 500);*****
        }*****
        function close_msg_dlg() {*****
          $('.chat-dlg-macconnect').animate({*****
            'height': '60px'*****
          }, 700);*****
          setTimeout((function() {*****
            $('.chat-dlg-macconnect .content').addClass('hidden');*****
          }), 200);*****
        }*****
        $('#macconnect_chat_dialog').dialog({*****
          autoOpen: false,*****
          resizable: false,*****
          height: 'auto',*****
          width: 300,*****
          modal: true,*****
          buttons: {*****
            'はい'() {*****
              $(this).dialog('close');*****
              open_msg_dlg();*****
            },*****
            'いいえ'() {*****
              $(this).dialog('close');*****
              close_msg_dlg();*****
            }*****
          }*****
        });*****
*****
        function process_dialog() {*****
          if (chatEnabled === true) {*****
            if (defaultEnable === true) {*****
              open_msg_dlg();*****
            } else {*****
              $( '#macconnect_chat_dialog' ).dialog( 'open' );*****
            }*****
          }*****
        }*****
*****
        $('.chat-dlg-macconnect').on('click', '.title', function() {*****
          if (chatEnabled === true) {*****
            if ($('.chat-dlg-macconnect').height() < 100) {*****
              open_msg_dlg();*****
            } else {*****
              close_msg_dlg();*****
            }*****
          }*****
        });*****
*****
        // DETECT CLOSING WINDOW*****
        var f5key, modifierPressed, modkey, refreshKeyPressed, rkey;*****
        refreshKeyPressed = false;*****
        modifierPressed = false;*****
        f5key = 116;*****
        rkey = 82;*****
        modkey = [17, 224, 91, 92, 93];*****
*****
        $(document).bind('keydown', function(evt) {*****
          if (evt.which === f5key || modifierPressed && evt.which === rkey) {*****
            refreshKeyPressed = true;*****
          }*****
          if (modkey.indexOf(evt.which) >= 0) {*****
            modifierPressed = true;*****
          }*****
        });*****
*****
        $(document).bind('keyup', function(evt) {*****
          if (evt.which === f5key || evt.which === rkey) {*****
            refreshKeyPressed = false;*****
          }*****
          if (modkey.indexOf(evt.which) >= 0) {*****
            modifierPressed = false;*****
          }*****
        });*****
*****
        $(window).bind('beforeunload', function(event) {*****
          if ($('#messages.user').length && refreshKeyPressed === false) {*****
            console.log('CLOSING');*****
            send_close();*****
          }*****
        });*****
      });*****
    </script>*****
    <div class='chat-dlg-macconnect'>*****
      <h2 class='title chat_dlg_animate'>。。。。。</h2>*****
      <div class='content hidden'>*****
        <div class='user' id='messages'>*****
        </div>*****
        <div class='send-box'>*****
          <div class='msg-field'>*****
            <textarea placeholder='こちらで入力' rows='2' required='required' id='maxconnect_message'></textarea>*****
            <input type='submit' value='送信' id='maxconnect_message_button'>*****
          </div>*****
        </div>*****
      </div>*****
    </div>*****
    <div id='macconnect_chat_dialog' title=''>*****
      <h3>オペレータからのお声がけしてよろしいですか？</h3>*****
    </div>")