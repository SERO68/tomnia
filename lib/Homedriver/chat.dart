// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tomnia/classes.dart';
import 'package:tomnia/model.dart';
import 'data.dart';
import 'theme.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Message> messages = [];
  AppTheme theme = LightTheme();
  final currentUser = ChatUser(
    id: '922a195f-918c-4174-b187-9d11fe552919',
    name: 'Flutter',
    profilePhoto: Data.profileImage,
  );

  late final ChatController _chatController;

  String? receiverId = '1b660aee-0b2a-4c54-8df8-23e82c9f277b';
  String? userId;

  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJzZXJvYWxleEB5YWhvby5jb20iLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjFiNjYwYWVlLTBiMmEtNGM1NC04ZGY4LTIzZTgyYzlmMjc3YiIsImp0aSI6ImViNTZkNjc4LTA0ZGItNDUyYS1iYjhkLTYyNGMyMTcxMGIzNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlBhc3NlbmdlciIsImV4cCI6MTcxODE1ODExNSwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NzE3NC8iLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo1MTczLyJ9.yQuTyXntZ8Aag3ob64d5zPIreXYqy06foX2FJCpwGEI';
  @override
  void initState() {
    super.initState();
    _chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      chatUsers: [
        ChatUser(
            id: '922a195f-918c-4174-b187-9d11fe552919',
            name: 'Simform',
            profilePhoto: Data.profileImage),
      ],
    );
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      userId = await fetchCurrentUser(token);
      receiverId = '1b660aee-0b2a-4c54-8df8-23e82c9f277b';
      await _loadMessages();
    } catch (e) {
      // Handle errors
      print('Error initializing chat: $e');
    }
  }

  Future<String?> fetchCurrentUser(String token) async {
    final url =
        Uri.parse('http://tomnaia.runasp.net/api/User/get-Current-user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null && json is Map<String, dynamic>) {
        return json['id'];
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch user: ${response.reasonPhrase}');
    }
  }Future<void> _loadMessages() async {
  if (receiverId == null || userId == null) return;

  final url = Uri.parse('http://tomnaia.runasp.net/api/Message/get?recieverId=$receiverId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> json = jsonDecode(response.body);
    final List<Message> fetchedMessages = json.map((messageJson) {
      return Message(
        id: messageJson['id'].toString(),
        createdAt: DateTime.parse(messageJson['timestamp']),
        message: messageJson['content'],
        sendBy: messageJson['senderId'],
        messageType: MessageType.text,
      );
    }).toList();

    setState(() {
      for (var msg in fetchedMessages) {
        _chatController.addMessage(msg);
      }
    });
  } else {
    throw Exception('Failed to load messages: ${response.reasonPhrase} ${response.body}');
  }
}



  Future<void> _sendMessage(String messageContent) async {
    if (receiverId == null || userId == null) return;

    final url = Uri.parse('http://tomnaia.runasp.net/api/Message/send?recieverId=$receiverId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'receiverId': receiverId,
        'content': messageContent,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.reasonPhrase} ${response.body}');
    }else{
      print('Message sent successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null || receiverId == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: ChatView(
        currentUser: currentUser,
        chatController: _chatController,
        onSendTap: (message, replyMessage, messageType) async {
          final id = int.parse(Data.messageList.last.id) + 1;
          final newMessage = Message(
            id: id.toString(),
            createdAt: DateTime.now(),
            message: message,
            sendBy: currentUser.id,
            replyMessage: replyMessage,
            messageType: messageType,
          );

          _chatController.addMessage(newMessage);

          try {
            await _sendMessage(message);
            Future.delayed(const Duration(milliseconds: 300), () {
              _chatController.initialMessageList.last.setStatus =
                  MessageStatus.undelivered;
            });
            Future.delayed(const Duration(seconds: 1), () {
              _chatController.initialMessageList.last.setStatus =
                  MessageStatus.read;
            });
          } catch (e) {
            // Handle errors
            print('Error sending message: $e');
          }
        },
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: true,
        ),
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        appBar: ChatViewAppBar(
          elevation: theme.elevation,
          backGroundColor: theme.appBarColor,
          profilePicture: Data.profileImage,
          backArrowColor: theme.backArrowColor,
          chatTitle: "Flutter",
          chatTitleTextStyle: TextStyle(
            color: theme.appBarTitleTextStyle,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.25,
          ),
          actions: const [],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
          allowRecordingVoice: false,
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            onMessageTyping: (status) {
              /// Do with status
              debugPrint(status.toString());
            },
            compositionThresholdTime: const Duration(seconds: 1),
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              backgroundColor: theme.linkPreviewOutgoingChatColor,
              bodyStyle: theme.outgoingChatLinkBodyStyle,
              titleStyle: theme.outgoingChatLinkTitleStyle,
            ),
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
            color: theme.outgoingChatBubbleColor,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: theme.linkPreviewIncomingChatColor,
              bodyStyle: theme.incomingChatLinkBodyStyle,
              titleStyle: theme.incomingChatLinkTitleStyle,
            ),
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            onMessageRead: (message) {
              /// send your message receipts to the other client
              debugPrint('Message Read');
            },
            senderNameTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          backgroundColor: theme.replyPopupColor,
          buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
          topBorderColor: theme.replyPopupTopBorderColor,
        ),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: theme.reactionPopupColor,
        ),
        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.messageReactionBackGroundColor,
            borderColor: theme.messageReactionBackGroundColor,
            reactedUserCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: theme.backgroundColor,
              reactedUserTextStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: theme.inComingChatBubbleColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            shareIconConfig: ShareIconConfiguration(
              defaultIconBackgroundColor: theme.shareIconBackgroundColor,
              defaultIconColor: theme.shareIconColor,
            ),
          ),
        ),
        profileCircleConfig: const ProfileCircleConfiguration(
          profileImageUrl: Data.profileImage,
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.repliedMessageColor,
          verticalBarColor: theme.verticalBarColor,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.pinkAccent.shade100,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
      ),
    );
  }
}
