{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        (discord.override {
          withVencord = true;
        })
      ];
      xdg.configFile."Vencord/themes/catppuccin-mocha.css".text = ''
        /**
        * @name Catppuccin Mocha
        * @author winston#0001
        * @authorId 505490445468696576
        * @version 0.2.0
        * @description 🎮 Soothing pastel theme for Discord
        * @website https://github.com/catppuccin/discord
        * @invite r6Mdz5dpFc
        * **/

        @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css");
      '';
      xdg.configFile."Vencord/settings/settings.json".text = builtins.toJSON {
        notifyAboutUpdates = true;
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
        themeLinks = [ ];
        enabledThemes = [
          "catppuccin-mocha.css"
        ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          ChatInputButtonAPI.enabled = false;
          CommandsAPI.enabled = true;
          DynamicImageModalAPI.enabled = false;
          MemberListDecoratorsAPI.enabled = false;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = false;
          MessageEventsAPI.enabled = false;
          MessagePopoverAPI.enabled = false;
          MessageUpdaterAPI.enabled = false;
          ServerListAPI.enabled = false;
          UserSettingsAPI.enabled = true;
          AccountPanelServerProfile.enabled = false;
          AlwaysAnimate.enabled = false;
          AlwaysExpandRoles.enabled = false;
          AlwaysTrust.enabled = true;
          AnonymiseFileNames.enabled = false;
          AppleMusicRichPresence.enabled = false;
          BANger.enabled = false;
          BetterFolders.enabled = false;
          BetterGifAltText.enabled = false;
          BetterGifPicker.enabled = false;
          BetterNotesBox.enabled = false;
          BetterRoleContext.enabled = false;
          BetterRoleDot.enabled = false;
          BetterSessions.enabled = false;
          BetterSettings.enabled = false;
          BetterUploadButton.enabled = false;
          BiggerStreamPreview.enabled = false;
          BlurNSFW.enabled = false;
          CallTimer.enabled = false;
          ClearURLs.enabled = true;
          ClientTheme.enabled = false;
          ColorSighted.enabled = false;
          ConsoleJanitor.enabled = false;
          ConsoleShortcuts.enabled = false;
          CopyEmojiMarkdown.enabled = false;
          CopyFileContents.enabled = true;
          CopyUserURLs.enabled = false;
          CrashHandler.enabled = true;
          CtrlEnterSend.enabled = false;
          CustomRPC.enabled = false;
          CustomIdle.enabled = false;
          Dearrow.enabled = false;
          Decor.enabled = false;
          DisableCallIdle.enabled = false;
          DontRoundMyTimestamps.enabled = false;
          EmoteCloner.enabled = true;
          Experiments.enabled = true;
          F8Break.enabled = false;
          FakeNitro.enabled = true;
          FakeProfileThemes.enabled = false;
          FavoriteEmojiFirst.enabled = false;
          FavoriteGifSearch.enabled = false;
          FixCodeblockGap.enabled = false;
          FixImagesQuality.enabled = false;
          FixSpotifyEmbeds.enabled = false;
          FixYoutubeEmbeds.enabled = false;
          ForceOwnerCrown.enabled = false;
          FriendInvites.enabled = false;
          FriendsSince.enabled = false;
          FullSearchContext.enabled = false;
          GameActivityToggle.enabled = false;
          GifPaste.enabled = false;
          GreetStickerPicker.enabled = false;
          HideAttachments.enabled = false;
          iLoveSpam.enabled = false;
          IgnoreActivities.enabled = false;
          ImageLink.enabled = false;
          ImageZoom.enabled = false;
          ImplicitRelationships.enabled = false;
          InvisibleChat.enabled = false;
          KeepCurrentChannel.enabled = false;
          LastFMRichPresence.enabled = false;
          LoadingQuotes.enabled = false;
          MemberCount.enabled = false;
          MentionAvatars.enabled = false;
          MessageClickActions.enabled = false;
          MessageLatency.enabled = false;
          MessageLinkEmbeds.enabled = false;
          # MessageLogger.enabled = false;
          MessageLogger = {
            enabled = true;
            logDeletes = true;
            collapseDeleted = false; # default: false
            logEdits = false; # default: true
            inlineEdits = false; # default: true
            ignoreBots = true; # default: false
            ignoreSelf = true; # default: false
          };
          MessageTags.enabled = false;
          MoreCommands.enabled = false;
          MoreKaomoji.enabled = false;
          MoreUserTags.enabled = false;
          Moyai.enabled = false;
          MutualGroupDMs.enabled = false;
          NewGuildSettings.enabled = false;
          NoBlockedMessages.enabled = false;
          NoDevtoolsWarning.enabled = false;
          NoF1.enabled = false;
          NoMaskedUrlPaste.enabled = false;
          NoMosaic.enabled = false;
          NoOnboardingDelay.enabled = false;
          NoPendingCount.enabled = false;
          NoProfileThemes.enabled = false;
          NoRPC.enabled = false;
          NoReplyMention.enabled = false;
          NoScreensharePreview.enabled = false;
          NoServerEmojis.enabled = false;
          NoSystemBadge.enabled = false;
          NoTypingAnimation.enabled = false;
          NoUnblockToJump.enabled = false;
          NormalizeMessageLinks.enabled = false;
          NotificationVolume.enabled = false;
          NSFWGateBypass.enabled = true;
          OnePingPerDM.enabled = false;
          oneko.enabled = false;
          OpenInApp.enabled = false;
          OverrideForumDefaults.enabled = false;
          PartyMode.enabled = false;
          PauseInvitesForever.enabled = false;
          PermissionFreeWill.enabled = false;
          PermissionsViewer.enabled = false;
          petpet.enabled = false;
          PictureInPicture.enabled = false;
          PinDMs.enabled = false;
          PlainFolderIcon.enabled = false;
          PlatformIndicators.enabled = false;
          PreviewMessage.enabled = false;
          QuickMention.enabled = false;
          QuickReply.enabled = false;
          ReactErrorDecoder.enabled = false;
          ReadAllNotificationsButton.enabled = false;
          RelationshipNotifier.enabled = false;
          ReplaceGoogleSearch = {
            enabled = true;
            customEngineName = "Startpage";
            customEngineURL = "https://www.startpage.com/sp/search?prfe=c602752472dd4a3d8286a7ce441403da08e5c4656092384ed3091a946a5a4a4c99962d0935b509f2866ff1fdeaa3c33a007d4d26e89149869f2f7d0bdfdb1b51aa7ae7f5f17ff4a233ff313d&query=";
          };
          ReplyTimestamp.enabled = false;
          RevealAllSpoilers.enabled = false;
          ReverseImageSearch.enabled = true;
          ReviewDB.enabled = false;
          RoleColorEverywhere.enabled = false;
          SecretRingToneEnabler.enabled = false;
          Summaries.enabled = false;
          SendTimestamps.enabled = false;
          ServerInfo.enabled = false;
          ServerListIndicators.enabled = false;
          ShikiCodeblocks.enabled = false;
          ShowAllMessageButtons.enabled = false;
          ShowConnections.enabled = false;
          ShowHiddenChannels = {
            enabled = false;
            hideUnreads = true;
            showMode = 1;
          };
          ShowHiddenThings.enabled = true;
          ShowMeYourName.enabled = false;
          ShowTimeoutDuration.enabled = false;
          SilentMessageToggle.enabled = false;
          SilentTyping = {
            enabled = true;
            showIcon = true;
            contextMenu = true;
            isEnabled = false; # Enable/Disable by default
          };
          SortFriendRequests.enabled = false;
          SpotifyControls.enabled = false;
          SpotifyCrack.enabled = true;
          SpotifyShareCommands.enabled = false;
          StartupTimings.enabled = false;
          StickerPaste.enabled = false;
          StreamerModeOnStream.enabled = false;
          SuperReactionTweaks.enabled = false;
          TextReplace.enabled = false;
          ThemeAttributes.enabled = false;
          Translate.enabled = false;
          TypingIndicator.enabled = false;
          TypingTweaks.enabled = false;
          Unindent.enabled = false;
          UnlockedAvatarZoom.enabled = false;
          UnsuppressEmbeds.enabled = false;
          UserMessagesPronouns.enabled = false;
          UserVoiceShow.enabled = false;
          USRBG.enabled = false;
          ValidReply.enabled = false;
          ValidUser.enabled = false;
          VoiceChatDoubleClick.enabled = false;
          VcNarrator.enabled = false;
          VencordToolbox.enabled = false;
          ViewIcons.enabled = false;
          ViewRaw.enabled = false;
          VoiceDownload.enabled = false;
          VoiceMessages.enabled = false;
          VolumeBooster.enabled = false;
          WhoReacted.enabled = false;
          XSOverlay.enabled = false;
          YoutubeAdblock.enabled = true;
          NoTrack.enabled = true;
          NoTrack.disableAnalytics = true;
          Settings.enabled = true;
          Settings.settingsLocation = "aboveNitro";
          SupportHelper.enabled = true;
        };
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };
        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1737589382741;
        };
      };
    })
  ];
}
