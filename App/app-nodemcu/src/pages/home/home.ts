import { SensorsService } from './../../services/sensors.service';
import { Component } from '@angular/core';
import { NavController, ToastController } from 'ionic-angular';

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
    private toastCtrl: ToastController
  ) {}

  async ionViewWillLoad() {
    try {
      await Promise.all([this.getSensors(), await this.getValues()]);
      this.sensorChanged();
    } catch (e) {
      console.log(e);
    }
  }

  async getSensors() {
    const response = await this.sensorsService.getSensors();
    this.sensors = response.data;
    this.sensorSelected = this.sensors[0];
  }

  async getValues() {
    const response = await this.sensorsService.getValues();
    this.values = response.data;
  }

  sensorChanged() {
    this.valuesToBeDisplayed = this.values.filter(v => v.sensor == this.sensorSelected);
  }

  displayTime(value) {
    var date = new Date(value.time * 1000);

    let toast = this.toastCtrl.create({
      message: `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()} - ${date.getHours()}:${date.getMinutes()}`,
      duration: 3000,
      position: 'middle'
    });
    toast.present();
  }
}
