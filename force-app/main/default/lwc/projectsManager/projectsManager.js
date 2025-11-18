import { LightningElement, track, wire } from 'lwc';
import getProjects from '@salesforce/apex/DigitalMarketingController.getProjects';
import createProject from '@salesforce/apex/DigitalMarketingController.createProject';
import updateProject from '@salesforce/apex/DigitalMarketingController.updateProject';
import deleteProject from '@salesforce/apex/DigitalMarketingController.deleteProject';

export default class ProjectsManager extends LightningElement {
    @track projects = [];
    @track error;
    @track projectName = '';
    @track projectId;

    @wire(getProjects)
    wiredProjects({ error, data }) {
        if (data) {
            this.projects = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.projects = [];
        }
    }

    handleProjectNameChange(event) {
        this.projectName = event.target.value;
    }

    handleCreateProject() {
        createProject({ name: this.projectName })
            .then(() => {
                this.projectName = '';
                return getProjects();
            })
            .then(data => {
                this.projects = data;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleUpdateProject() {
        updateProject({ id: this.projectId, name: this.projectName })
            .then(() => {
                this.projectName = '';
                this.projectId = null;
                return getProjects();
            })
            .then(data => {
                this.projects = data;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleDeleteProject(event) {
        const projectId = event.target.dataset.id;
        deleteProject({ id: projectId })
            .then(() => {
                return getProjects();
            })
            .then(data => {
                this.projects = data;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleEditProject(event) {
        this.projectId = event.target.dataset.id;
        const project = this.projects.find(proj => proj.Id === this.projectId);
        this.projectName = project.Name;
    }
}