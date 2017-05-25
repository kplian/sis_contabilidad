<?php
/**
*@package pXP
*@file gen-MODIntTransVal.php
*@author  (admin)
*@date 01-09-2013 18:04:55
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODIntTransVal extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarIntTransVal(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_trans_val_sel';
		$this->transaccion='CONTA_TRAVAL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_trans_val','int4');
		$this->captura('importe_haber','numeric');
		$this->captura('importe_gasto','numeric');
		$this->captura('importe_recurso','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('id_int_transaccion','int4');
		$this->captura('importe_debe','numeric');
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
			
	function insertarIntTransVal(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_trans_val_ime';
		$this->transaccion='CONTA_TRAVAL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('importe_debe','importe_debe','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarIntTransVal(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_trans_val_ime';
		$this->transaccion='CONTA_TRAVAL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_trans_val','id_int_trans_val','int4');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('importe_debe','importe_debe','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarIntTransVal(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_trans_val_ime';
		$this->transaccion='CONTA_TRAVAL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_trans_val','id_int_trans_val','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>