<?php
/**
*@package pXP
*@file gen-MODIntTransaccion.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODIntTransaccion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTRANSA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_moneda','id_moneda','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('importe_debe','numeric');	
		$this->captura('importe_haber','numeric');
		$this->captura('importe_gasto','numeric');
		$this->captura('importe_recurso','numeric');
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		$this->captura('desc_partida','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_cuenta','text');
		$this->captura('desc_auxiliar','text');
		$this->captura('tipo_partida','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_transaccion_fk','id_int_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		$this->setParametro('importe_debe_mb','importe_debe','numeric');
		$this->setParametro('importe_haber_mb','importe_haber','numeric');
		$this->setParametro('importe_gasto_mb','importe_gasto','numeric');
		$this->setParametro('importe_recurso_mb','importe_recurso','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_transaccion_fk','id_int_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','text');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		$this->setParametro('importe_debe_mb','importe_debe','numeric');
		$this->setParametro('importe_haber_mb','importe_haber','numeric');
		$this->setParametro('importe_gasto_mb','importe_gasto','numeric');
		$this->setParametro('importe_recurso_mb','importe_recurso','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>