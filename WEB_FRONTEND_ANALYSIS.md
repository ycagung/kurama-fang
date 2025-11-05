# Web Frontend Feature Analysis

## Overview
The web frontend (SvelteKit + TypeScript) provides the following features that should be replicated in the Flutter mobile app.

## Core Features

### 1. Navigation Structure
- **Sidebar Navigation**:
  - Profile switcher at top
  - Main navigation: Chat, Dayviewer
  - Chat sidebar (when in chat section) showing conversation list
  - User nav at bottom with actions (new chat, new contact, new schedule)

### 2. Chat Functionality

#### Chat List Page (`/home/[profileId]/chat`)
- Displays list of conversations (DisplayChatRoomData[])
- Each conversation shows:
  - Partner name/avatar
  - Last message preview
  - Click to open conversation

#### Individual Chat Page (`/home/[profileId]/chat/[chatId]`)

**Components:**
- **ConversationHeader**:
  - Partner avatar/name
  - Online/offline status indicator
  - Typing indicator ("Typing..." when partner is typing)
  - Menu button

- **ConversationBubble**:
  - Message content
  - Timestamp (HH:mm format)
  - Different styling for sent vs received messages
  - Grouped by date with date headers

- **ConversationFooter**:
  - Text input field
  - Send button
  - Enter key to send

**Real-time Features:**
- Socket events:
  - `join-room` - Join chat room on mount
  - `new-message` - Send message
  - `user-start-typing` - When user starts typing
  - `user-stop-typing` - When user stops typing
  - `[profileId]-connected` - Partner comes online
  - `[profileId]-disconnected` - Partner goes offline
  - `[profileId]-started-typing` - Partner starts typing
  - `[profileId]-stopped-typing` - Partner stops typing
  - `new-message-from-[senderId]-in-[chatId]` - Receive new message

**Message Organization:**
- Messages grouped by date (e.g., "MMM D, YYYY")
- Scrollable area with auto-scroll to bottom
- Messages sorted chronologically

### 3. Dayviewer/Schedule

**Features:**
- Calendar view showing schedules
- Create new schedule
- View/edit schedule details
- Schedule invitations

### 4. Profile Management

**Profile Switcher:**
- Switch between multiple profiles
- Create new profile
- Profile notifications (unread counts)

### 5. Forms

**New Chat Form:**
- Create new conversation with contact

**New Contact Form:**
- Add new contact
- Link to existing profile

**New Schedule Form:**
- Create schedule with date/time
- Invite members

**New Profile Form:**
- Create additional profile for account

**Edit Schedule Form:**
- Edit existing schedule details

## Socket Implementation

```typescript
// Socket connection
socket = io(PUBLIC_SOCKET_URL, {
  withCredentials: true,
  autoConnect: false
});

// Join room
socket.emit('join-room', roomId);

// Send message
socket.emit('new-message', { payload, roomId }, callback);

// Typing indicators
socket.emit('user-start-typing', { profileId, roomId });
socket.emit('user-stop-typing', { profileId, roomId });

// Listen for events
socket.on(`new-message-from-${senderId}-in-${chatId}`, handler);
socket.on(`${profileId}-connected`, handler);
socket.on(`${profileId}-started-typing`, handler);
```

## Data Structures

### DisplayChatRoomData
- id: string
- lastMessage: Message
- partner: ChatPartner

### Message
- id: string
- createdAt: Date
- senderId: string
- content: string
- statusId: string

### ChatPartner
- firstName: string
- lastName?: string
- profile: ProfileData
- blocked?: boolean

## UI Patterns

1. **Dark mode support** - Uses dark: prefix for dark theme
2. **Responsive design** - Mobile-friendly layouts
3. **Loading states** - Loading store for async operations
4. **Error handling** - Error store for error management
5. **Toast notifications** - Using sonner for notifications

## Implementation Checklist for Flutter

- [ ] Chat list page with conversation items
- [ ] Individual chat page with:
  - [ ] Header with partner info, online status, typing indicator
  - [ ] Message bubbles grouped by date
  - [ ] Input footer with send button
  - [ ] Auto-scroll to bottom
- [ ] Real-time socket integration:
  - [ ] Join/leave rooms
  - [ ] Send/receive messages
  - [ ] Typing indicators
  - [ ] Online/offline status
- [ ] Dayviewer/schedule functionality
- [ ] Profile switcher
- [ ] Forms for new chat, contact, schedule, profile
- [ ] Navigation structure matching web app

