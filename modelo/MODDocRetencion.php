<?php
/**
*@package pXP
*@file gen-MODDocRetencion.php
*@author  (manu)
*@date 18-08-2015 15:57:09
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
class MODDocRetencion extends MODbase{
	//
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}	
	//
	function listarRetForm(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_retencion_sel';
		$this->transaccion='CONTA_REPRET_FRM';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		
		$this->setParametro('filtro_sql','filtro_sql','VARCHAR');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('tipo_ret','tipo_ret','VARCHAR');
		$this->setParametro('fecha_ini','fecha_ini','DATE');
		$this->setParametro('fecha_fin','fecha_fin','DATE');
		$this->setParametro('id_gestion','id_gestion','int4');

		$this->captura('id_doc_compra_venta','BIGINT');
		$this->captura('tipo','VARCHAR');
		$this->captura('fecha','DATE');
		$this->captura('nit','VARCHAR');
		$this->captura('razon_social','VARCHAR');
		
		$this->captura('nro_documento','VARCHAR');		
		$this->captura('tipo_doc','VARCHAR');
		$this->captura('id_plantilla','INTEGER');
		$this->captura('tipo_informe','VARCHAR');		
		$this->captura('id_moneda','INTEGER');
		
		$this->captura('codigo_moneda','VARCHAR');
		$this->captura('id_periodo','INTEGER');
		$this->captura('id_gestion','INTEGER');
		$this->captura('id_usuario_reg','VARCHAR');
		$this->captura('importe_doc','NUMERIC');
		
		$this->captura('importe_descuento_ley','NUMERIC');
		$this->captura('obs','VARCHAR');
		$this->captura('nro_tramite','VARCHAR');
		$this->captura('plantilla','VARCHAR');
		
		$this->captura('it','NUMERIC');
		
		$this->captura('it_bienes','NUMERIC');
		$this->captura('it_servicios','NUMERIC');
		$this->captura('it_alquileres','NUMERIC');
				
		$this->captura('iue_iva','NUMERIC');
		 
		$this->captura('iue_iva_total','NUMERIC');
		
		$this->captura('iue_bienes','NUMERIC');
		$this->captura('iue_servicios','NUMERIC');
		$this->captura('rc_iva_alquileres','NUMERIC');
		 
		$this->captura('descuento','NUMERIC');
		$this->captura('liquido','NUMERIC');	
		
		$this->captura('bienes','VARCHAR');	
		$this->captura('servicios','VARCHAR');	
		$this->captura('alquileres','VARCHAR');	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}	
}
?>		
