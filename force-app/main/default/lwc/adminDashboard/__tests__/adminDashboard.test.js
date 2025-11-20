import { createElement } from 'lwc';
import AdminDashboard from 'c/adminDashboard';

describe('c-admin-dashboard', () => {
    afterEach(() => {
        // Clean up DOM after each test
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders the component', () => {
        const element = createElement('c-admin-dashboard', {
            is: AdminDashboard
        });
        document.body.appendChild(element);

        // Check that component is rendered
        expect(element).toBeTruthy();
    });

    it('shows loading spinner when no data', () => {
        const element = createElement('c-admin-dashboard', {
            is: AdminDashboard
        });
        document.body.appendChild(element);

        // Check that loading spinner is present
        const spinner = element.shadowRoot.querySelector('lightning-spinner');
        expect(spinner).not.toBeNull();
    });
});
