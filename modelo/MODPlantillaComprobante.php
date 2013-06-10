<?php
/**
*@package pXP
*@file gen-MODPlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:40:00
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPlantillaComprobante extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_plantilla_comprobante_sel';
		$this->transaccion='CONTA_CMPB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_plantilla_comprobante','int4');
		$this->captura('comprobante_eliminado','text');
		$this->captura('id_tabla','varchar');
		$this->captura('subistema','text');
		$this->captura('descripcion','text');
		$this->captura('comprobante_controlado','text');
		$this->captura('fecha','text');
		$this->captura('estado_reg','varchar');
		$this->captura('acreedor','text');
		$this->captura('depto','text');
		$this->captura('momento_presupuestario','varchar');
		$this->captura('fk_comprobante','text');
		$this->captura('tabla_origen','varchar');
		$this->captura('clase_comprobante','varchar');
		$this->captura('moneda','text');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPB_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('comprobante_eliminado','comprobante_eliminado','text');
		$this->setParametro('id_tabla','id_tabla','varchar');
		$this->setParametro('subistema','subistema','text');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('comprobante_controlado','comprobante_controlado','text');
		$this->setParametro('fecha','fecha','text');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('acreedor','acreedor','text');
		$this->setParametro('depto','depto','text');
		$this->setParametro('momento_presupuestario','momento_presupuestario','varchar');
		$this->setParametro('fk_comprobante','fk_comprobante','text');
		$this->setParametro('tabla_origen','tabla_origen','varchar');
		$this->setParametro('clase_comprobante','clase_comprobante','varchar');
		$this->setParametro('moneda','moneda','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPB_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','int4');
		$this->setParametro('comprobante_eliminado','comprobante_eliminado','text');
		$this->setParametro('id_tabla','id_tabla','varchar');
		$this->setParametro('subistema','subistema','text');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('comprobante_controlado','comprobante_controlado','text');
		$this->setParametro('fecha','fecha','text');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('acreedor','acreedor','text');
		$this->setParametro('depto','depto','text');
		$this->setParametro('momento_presupuestario','momento_presupuestario','varchar');
		$this->setParametro('fk_comprobante','fk_comprobante','text');
		$this->setParametro('tabla_origen','tabla_origen','varchar');
		$this->setParametro('clase_comprobante','clase_comprobante','varchar');
		$this->setParametro('moneda','moneda','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPB_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>