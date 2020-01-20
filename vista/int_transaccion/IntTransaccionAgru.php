<?php
/*
#75 		28/11/2019		  Manuel Guerra	  controlling
#93         16/1/2020         manuel guerra   modificacion en interfaz, ocultar columnas
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.IntTransaccionAgru=Ext.extend(Phx.gridInterfaz,{
        constructor:function(config){
            this.maestro=config.maestro;
            this.Atributos = [
                {
                    config:{
                        name: 'id',
                        fieldLabel: 'id',
                        inputType:'hidden',
                        gwidth: 100
                    },
                    type:'Field',
                    id_grupo:0,
                    grid:true,
                },
                {
                    config:{
                        name: 'tipo',
                        fieldLabel: 'Tipo',
                        allowBlank: true,
                        gwidth: 100,
                        renderer: function(value, metaData, record) {
                            return String.format('{0}', record.data['tipo'], value);
                        }
                    },
                    type:'Field',
                    filters:{pfiltro:'tipo',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:false
                },
                //
                {
                    config:{
                        name:'monto_mb',
                        inputType:'hidden',
                        fieldLabel: '% Ejecutado',
                        width: '100%',
                        gwidth: 110,
                        galign: 'right',
                        maxLength: 100,
                        decimalPrecision: 2,
                        renderer:function (value,p,record){
                            return String.format('{0}', '<FONT COLOR="black"><b>'+Ext.util.Format.number(record.data['monto_mb'],'0,000.00')+'</b></FONT>');
                        }
                    },
                    type:'NumberField',
                    grid:false
                },
                {
                    config:{
                        name:'ejecutado',
                        fieldLabel: '% Ejecucion/ejecutado',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 110,
                        galign: 'right',
                        maxLength: 100,
                        decimalPrecision: 2,
                        renderer:function (value,p,record){
                            if (record.data['ejecutado']<0.75) {
                                return String.format('{0}', '<FONT COLOR="red"><b>'+Ext.util.Format.number(record.data['ejecutado'],'0,000.00')+'</b></FONT>');
                            }else{
                                if(record.data['ejecutado']>0.75 && record.data['ejecutado']<0.90) {
                                    return String.format('{0}', '<FONT COLOR="blue"><b>'+Ext.util.Format.number(record.data['ejecutado'],'0,000.00')+'</b></FONT>');
                                }else{
                                    return String.format('{0}', '<FONT COLOR="green"><b>'+Ext.util.Format.number(record.data['ejecutado'],'0,000.00')+'</b></FONT>');
                                }
                            }
                        }
                    },
                    type:'NumberField',
                    id_grupo:1,
                    grid:true
                },//#93
                {
                    config: {
                        name: 'ejec',
                        fieldLabel: 'Ejecutado(Presupuestario)',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 110,
                        galign: 'right',
                        maxLength: 100,
                        summaryType: 'sum',
                        renderer:function (value,p,record){
                            if(record.data.tipo_reg != 'summary'){
                                return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'ejec',type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'formu',
                        fieldLabel: 'Formulado(Presupuestario)',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 110,
                        galign: 'right',
                        maxLength: 100,
                        summaryType: 'sum',
                        renderer:function (value,p,record){
                            if(record.data.tipo_reg != 'summary'){
                                return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                return  String.format('<b size=2 >{0}<b>', Ext.util.Format.number(value,'0,000.00'));
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'formu',type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                /*{
		   			config:{
		       		    name:'ejecutado',
		       		    fieldLabel: '% Ejecutado/ejecutado',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 110,
                        galign: 'right',
                        maxLength: 100,
                        decimalPrecision: 2,
                        renderer:function (value,p,record){
                        	return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                        }
		       	    },
		   			type:'NumberField',
		   			id_grupo:1,
		   			grid:true
			   	},*/
                {
                    config: {
                        name: 'compro',
                        fieldLabel: 'Comprometido(Presupuestario)',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 110,
                        galign: 'right',
                        maxLength: 100,
                        summaryType: 'sum',
                        renderer:function (value,p,record){
                            if(record.data.tipo_reg != 'summary'){
                                return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'compro',type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'importe_debe_mb',
                        fieldLabel: 'Debe MB(Contable)',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 150,
                        galign: 'right ',
                        summaryType: 'sum',
                        renderer:function (value,p,record){
                            if(record.data.tipo_reg != 'summary'){
                                return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'importe_debe_mb',type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'importe_haber_mb',
                        fieldLabel: 'Haber MB(Contable)',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 150,
                        galign: 'right',
                        summaryType: 'sum',
                        renderer:function (value,p,record){
                            if(record.data.tipo_reg != 'summary'){
                                return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'importe_haber_mb',type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },{
                    config: {
                        name: 'importe_debe_mt',
                        fieldLabel: 'Debe MT(Contable)',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 150,
                        galign: 'right',
                        summaryType: 'sum',
                        renderer:function (value,p,record){
                            if(record.data.tipo_reg != 'summary'){
                                return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'importe_debe_mt',type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },{
                    config: {
                        name: 'importe_haber_mt',
                        fieldLabel: 'Haber MT(Contable)',
                        allowBlank: true,
                        width: '100%',
                        gwidth: 150,
                        galign: 'right',
                        renderer:function (value,p,record){
                            if(record.data.tipo_reg != 'summary'){
                                return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
                            }
                            else{
                                return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'importe_haber_mt',type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },{
                    config:{
                        name: 'desde',
                        fieldLabel: 'Desde',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value){
                            return value?value.dateFormat('d/m/Y'):''
                        }
                    },
                    type:'DateField',
                    id_grupo:1,
                    grid:false,
                },{
                    config:{
                        name: 'hasta',
                        fieldLabel: 'hasta',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value){
                            return value?value.dateFormat('d/m/Y'):''
                        }
                    },
                    type:'DateField',
                    id_grupo:1,
                    grid:false,
                },{
                    config:{
                        name:'id_tipo_cc',
                    },
                    type:'Field',
                    id_grupo:1,
                    grid:false
                },{
                    config:{
                        name:'numero',
                        fieldLabel: 'ppp',
                    },
                    type:'Field',
                    id_grupo:1,
                    grid:false
                },{
                    config:{
                        name:'id_gestion',
                    },
                    type:'Field',
                    id_grupo:2,
                    grid:false
                },{
                    config:{
                        name:'id_periodo',
                    },
                    type:'Field',
                    id_grupo:2,
                    grid:false
                },
            ];
            Phx.vista.IntTransaccionAgru.superclass.constructor.call(this,config);
            this.init();
        },
        tam_pag: 50,
        ActList: '../../sis_contabilidad/control/IntTransaccion/listarAgrupacion',
        id_store: 'tipo',
        fields: [
            { name:'tipo', type: 'varchar'},
            { name:'importe_haber_mb', type: 'numeric'},
            { name:'importe_debe_mb', type: 'numeric'},
            { name:'importe_haber_mt', type: 'numeric'},
            { name:'importe_debe_mt', type: 'numeric'},

            { name:'desde', type:'date'},
            { name:'hasta', type:'date'},
            { name:'id_tipo_cc', type: 'integer'},
            //  { name:'id_subsistema', type: 'integer'},
            { name:'id', type: 'integer'},
            { name:'monto_mb', type: 'numeric'},

            { name:'ejecutado', type: 'numeric'},
            { name:'formulado', type: 'numeric'},

            { name:'compro', type: 'numeric'},
            { name:'ejec', type: 'numeric'},
            { name:'formu', type: 'numeric'},
            'numero',
            { name:'id_gestion', type: 'integer'},
            { name:'id_periodo', type: 'integer'},
        ],
        sortInfo:{
            field: 'tipo',
            direction: 'ASC'
        },
        bdel: false,
        bsave: false,
        bedit: false,
        bnew: false,

        onReloadPage:function(param){
            //Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
            this.initFiltro(param);
            //this.loadValoresIniciales();
        },
        initFiltro: function(param){
            console.log('param',param);
            // Phx.CP.loadingShow();
            this.store.baseParams={
                id_tipo_cc:param.id_tipo_cc,
                numero:param.id_tipo_cc,
                desde: param.desde,
                hasta: param.hasta,
                ejecutado: param.ejecutado,
                id_gestion: param.id_gestion1,
                id_periodo: param.id_periodo,

            };
            // this.store.baseParams=param;
            this.load({ params: { start:0, limit: this.tam_pag } });
        },

        south:{
            url: '../../../sis_contabilidad/vista/int_transaccion/IntTransaccionCtrl.php',
            height:'55%',
            cls: 'IntTransaccionCtrl',
            title:'Transacciones'
        },

    })
</script>
