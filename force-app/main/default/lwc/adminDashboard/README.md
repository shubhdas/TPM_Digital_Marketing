# Admin Dashboard

This component provides a personalized dashboard for administrators with key metrics and quick actions.

## Features

- **KPI Cards**: Displays counts for Leads, Clients, Campaigns, Projects, and Billing
- **Personalized View**: Toggle between default and personalized layouts
- **Widget Customization**: Select which widgets to display
- **Quick Actions**: Buttons for common administrative tasks
- **Responsive Design**: Works on desktop and mobile devices

## Personalization Options

The dashboard supports several personalization features:

1. **Personalized View Toggle**: Switch between default and customizable views
2. **Widget Selection**: Choose which KPI cards to display
3. **Quick Actions Visibility**: Show/hide the quick actions panel
4. **User Preferences**: Saves preferences in browser's localStorage

## Usage

The component is designed to be used on Lightning App Pages and Home Pages. It automatically loads data from the backend Apex controller and displays it in a responsive grid layout.

## Customization

To customize this component:

1. Modify the HTML template to change the layout
2. Update the JavaScript to add new data sources or functionality
3. Adjust the CSS to change the appearance
4. Extend the personalization features as needed

## Testing

This component includes unit tests to ensure proper functionality. Run tests using:

```bash
sf project test run --test-name-pattern=adminDashboard
