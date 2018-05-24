import { SensorsService } from './../../services/sensors.service';
import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { UtilService } from '../../util/util.service';

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {
  
  public sensors = [];
  public sensorSelected;
  public values = [];
  public valuesToBeDisplayed = [];

  constructor(
    public navCtrl: NavController,
    private sensorsService: SensorsService,
    private utilService: UtilService
  ) {}

  async ionViewWillLoad() {
    try {
      this.utilService.showLoading();
      await Promise.all([this.getSensors(), await this.getValues()]);
      this.sensorChanged();
    } catch (e) {
      console.log(e);
      this.utilService.errorMessage('Erro ao carregar as informações sobre os sensores');
    } finally {
      this.utilService.dismissLoading();
    }
  }

  private async getSensors() {
    const response = await this.sensorsService.getSensors();
    this.sensors = response.data;
    this.sensorSelected = this.sensors[0];
  }

  private async getValues() {
    const response = await this.sensorsService.getValues();
    this.values = response.data;
  }

  public sensorChanged() {
    this.valuesToBeDisplayed = this.values.filter(v => v.sensor == this.sensorSelected);
  }
}
