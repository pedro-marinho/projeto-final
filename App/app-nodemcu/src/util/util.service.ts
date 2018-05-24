import { Injectable } from '@angular/core';
import { LoadingController, AlertController } from 'ionic-angular';

@Injectable()
export class UtilService {

    private loader;

    constructor(
        private loadingCtrl: LoadingController,
        private alertCtrl: AlertController
    ) {}

    public showLoading() {
        this.loader = this.loadingCtrl.create({
            content: 'Aguarde ...'
        });
        this.loader.present();
    }

    public dismissLoading() {
        this.loader.dismiss();
    }

    public errorMessage(msg: string, title?: string) {
        let alert = this.alertCtrl.create({
            title: title ? title : 'Erro',
            subTitle: msg,
            buttons: ['OK']
        });
        alert.present();
    }
}