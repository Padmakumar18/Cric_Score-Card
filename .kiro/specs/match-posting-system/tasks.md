# Implementation Plan

- [x] 1. Create data models for match posting system

  - Create MatchPost model with enums for BallType, MatchType, and MatchPostStatus
  - Create ApproachRequest model with ApproachRequestStatus enum
  - Create UserStatistics model with ball type breakdown map
  - Implement JSON serialization methods (toJson, fromJson) for all models
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.6, 3.4, 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ] 2. Extend API service with match posting endpoints

  - Add createMatchPost endpoint method
  - Add getMatchPosts endpoint with filter parameters
  - Add getMatchPost endpoint for single match retrieval
  - Add updateMatchPost and deleteMatchPost endpoints
  - Add sendApproachRequest endpoint
  - Add getIncomingRequests and getOutgoingRequests endpoints
  - Add acceptApproachRequest and rejectApproachRequest endpoints
  - Add getUserStatistics endpoint
  - _Requirements: 1.2, 2.1, 3.2, 4.3, 4.4, 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ] 3. Implement MatchPostProvider for state management

  - Create MatchPostProvider class extending ChangeNotifier
  - Implement createMatchPost method with API integration
  - Implement fetchMatchPosts method with pagination support
  - Implement filter application logic (ball type, overs, venue)
  - Add loading and error state management
  - Implement clearFilters method
  - Add selectMatchPost method for viewing details
  - _Requirements: 1.2, 1.5, 2.1, 2.2, 2.3, 2.4, 2.5_

- [ ] 4. Implement ApproachRequestProvider for request management

  - Create ApproachRequestProvider class extending ChangeNotifier
  - Implement sendApproachRequest method with duplicate prevention
  - Implement fetchIncomingRequests method
  - Implement fetchOutgoingRequests method
  - Implement acceptRequest method with auto-rejection of other requests
  - Implement rejectRequest method
  - Add hasApproached helper method to check existing requests
  - Add notification state management
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 4.1, 4.2, 4.3, 4.4, 4.5_

- [ ] 5. Implement StatisticsProvider for user statistics

  - Create StatisticsProvider class extending ChangeNotifier
  - Implement fetchStatistics method
  - Implement refreshStatistics method
  - Add getMatchesByBallType helper method
  - Add getWinPercentage calculation method
  - Implement caching logic for statistics data
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6_

- [ ] 6. Create reusable widget components

  - Create MatchPostCard widget with match details display
  - Create FilterChip widget for filter selection
  - Create StatisticCard widget for dashboard metrics
  - Create ApproachRequestCard widget with accept/reject actions
  - Implement proper touch target sizes (48x48 dp minimum)
  - Add semantic labels for accessibility
  - _Requirements: 2.6, 6.1, 6.5_

- [ ] 7. Build MatchPostFormScreen for creating match posts

  - Create MatchPostFormScreen with form fields
  - Add text fields for team name, venue, total players, total overs
  - Add dropdown for ball type selection (Red Ball, Stitch Ball, Tennis Ball)
  - Add dropdown for match type selection (Bet Match, Friendly Match)
  - Add date/time picker for match timing
  - Implement form validation with inline error messages
  - Add submit button with loading state
  - Integrate with MatchPostProvider
  - Show success confirmation on post creation
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 6.2, 6.3_

- [ ] 8. Build MatchBrowserScreen for browsing matches

  - Create MatchBrowserScreen with scrollable list
  - Implement filter bar with ball type, overs, and venue filters
  - Display match posts using MatchPostCard widgets
  - Add pull-to-refresh functionality
  - Implement pagination for match loading
  - Add empty state when no matches found
  - Add loading skeleton/shimmer effect
  - Integrate with MatchPostProvider
  - Handle filter application and clearing
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 6.1, 6.2_

- [ ] 9. Build ApproachRequestsScreen for managing requests

  - Create ApproachRequestsScreen with tab bar
  - Implement "Incoming" tab with incoming requests list
  - Implement "Outgoing" tab with outgoing requests list
  - Display requests using ApproachRequestCard widgets
  - Add accept/reject buttons for incoming requests
  - Show status indicators for outgoing requests
  - Add empty state messages for both tabs
  - Integrate with ApproachRequestProvider
  - Show notification indicator for new requests
  - _Requirements: 3.1, 3.2, 3.3, 4.1, 4.2, 4.3, 4.4, 4.5, 6.3_

- [ ] 10. Build StatisticsDashboardScreen for user statistics

  - Create StatisticsDashboardScreen layout
  - Add summary cards for matches posted, approached, and played
  - Display win/loss/draw breakdown with visual indicators
  - Show ball type breakdown (Red, Stitch, Tennis)
  - Add refresh button for updating statistics
  - Integrate with StatisticsProvider
  - Implement loading and error states
  - Use StatisticCard widgets for consistent display
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 6.1_

- [ ] 11. Integrate match posting system into app navigation

  - Add match posting menu items to HomeScreen navigation
  - Create navigation routes for all new screens
  - Integrate with existing navigation patterns
  - Add deep linking support for match posts (optional)
  - Ensure proper back button behavior
  - _Requirements: 6.2_

- [ ] 12. Register providers in main.dart

  - Add MatchPostProvider to MultiProvider
  - Add ApproachRequestProvider to MultiProvider
  - Add StatisticsProvider to MultiProvider
  - Ensure proper provider initialization order
  - _Requirements: All requirements_

- [ ] 13. Implement error handling and user feedback

  - Add error handling for network failures
  - Implement retry mechanisms for failed requests
  - Show success snackbars for completed actions
  - Display user-friendly error messages
  - Add loading indicators for all async operations
  - Implement optimistic updates where appropriate
  - _Requirements: 6.3_

- [ ] 14. Apply theme and styling consistency

  - Use existing app theme colors and typography
  - Ensure consistent spacing throughout all screens
  - Apply Material Design elevation and shadows
  - Support light and dark mode
  - Ensure responsive layouts for different screen sizes
  - _Requirements: 6.1, 6.4_

- [ ] 15. Write unit tests for models and providers

  - Write tests for MatchPost model serialization
  - Write tests for ApproachRequest model serialization
  - Write tests for UserStatistics model
  - Write tests for MatchPostProvider state management
  - Write tests for ApproachRequestProvider logic
  - Write tests for StatisticsProvider calculations
  - Create mock data factories for testing
  - _Requirements: All requirements_

- [ ] 16. Write widget tests for screens and components
  - Write tests for MatchPostFormScreen validation
  - Write tests for MatchBrowserScreen filtering
  - Write tests for ApproachRequestsScreen actions
  - Write tests for StatisticsDashboardScreen display
  - Write tests for MatchPostCard rendering
  - Write tests for FilterChip selection
  - Write tests for StatisticCard display
  - Write tests for ApproachRequestCard actions
  - _Requirements: All requirements_
