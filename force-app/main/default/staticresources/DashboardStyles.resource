/* Dashboard Styles for Personalization */
.kpi-card {
    border: 1px solid #e1dfdd;
    border-radius: 0.25rem;
    box-shadow: 0 2px 2px 0 rgba(0,0,0,0.1);
}

.kpi-value {
    font-size: 2rem;
    font-weight: bold;
    text-align: center;
    color: #0070d2;
}

.slds-card__header-title {
    font-weight: 600;
}

/* Widget selection panel styling */
.slds-card--custom {
    border: 1px solid #e1dfdd;
    border-radius: 0.25rem;
    box-shadow: 0 2px 2px 0 rgba(0,0,0,0.1);
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .slds-col {
        flex: 0 0 100%;
        max-width: 100%;
    }
    
    .kpi-value {
        font-size: 1.5rem;
    }
}
