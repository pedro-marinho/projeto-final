import { Url } from './url.service';
import { Http } from '@angular/http';
import { Injectable } from '@angular/core';
import { Environment } from '../environments/environment';

@Injectable()
export class SensorsService {

    constructor(private http: Http) {}

    async getSensors() {
        const response = await this.http.get(Environment.urlApi + Url.sensors).toPromise();
        
        return response.json();
    }

    async getValues() {
        const response = await this.http.get(Environment.urlApi + Url.values).toPromise();
        
        return response.json();
    }
}
