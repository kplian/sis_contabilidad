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
		$this->captura('funcion_comprobante_eliminado','text');
		$this->captura('id_tabla','varchar');
		$this->captura('campo_subsistema','text');
		$this->captura('campo_descripcion','text');
		$this->captura('funcion_comprobante_validado','text');
		$this->captura('campo_fecha','text');
		$this->captura('estado_reg','varchar');
		$this->captura('campo_acreedor','text');
		$this->captura('campo_depto','text');
		$this->captura('momento_presupuestario','varchar');
		$this->captura('campo_fk_comprobante','text');
		$this->captura('tabla_origen','varchar');
		$this->captura('clase_comprobante','varchar');
		$this->captura('campo_moneda','text');
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
		$this->setParametro('funcion_comprobante_eliminado','funcion_comprobante_eliminado','text');
		$this->setParametro('id_tabla','id_tabla','varchar');
		$this->setParametro('campo_subsistema','campo_subsistema','consulta_select');
		$this->setParametro('campo_descripcion','campo_descripcion','consulta_select');
		$this->setParametro('funcion_comprobante_validado','funcion_comprobante_validado','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('campo_acreedor','campo_acreedor','consulta_select');
		$this->setParametro('campo_depto','campo_depto','consulta_select');
		$this->setParametro('momento_presupuestario','momento_presupuestario','varchar');
		$this->setParametro('campo_fk_comprobante','campo_fk_comprobante','consulta_select');
		$this->setParametro('tabla_origen','tabla_origen','text');
		$this->setParametro('clase_comprobante','clase_comprobante','varchar');
		$this->setParametro('campo_moneda','campo_moneda','consulta_select');

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
		$this->setParametro('funcion_comprobante_eliminado','funcion_comprobante_eliminado','consulta_select');
		$this->setParametro('id_tabla','id_tabla','varchar');
		$this->setParametro('campo_subsistema','campo_subsistema','consulta_select');
		$this->setParametro('campo_descripcion','campo_descripcion','consulta_select');
		$this->setParametro('funcion_comprobante_validado','funcion_comprobante_validado','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('campo_acreedor','campo_acreedor','consulta_select');
		$this->setParametro('campo_depto','campo_depto','consulta_select');
		$this->setParametro('momento_presupuestario','momento_presupuestario','varchar');
		$this->setParametro('campo_fk_comprobante','campo_fk_comprobante','consulta_select');
		$this->setParametro('tabla_origen','tabla_origen','varchar');
		$this->setParametro('clase_comprobante','clase_comprobante','varchar');
		$this->setParametro('campo_moneda','campo_moneda','consulta_select');

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