<?php
/**
*@package pXP
*@file gen-MODTransaccion.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTransaccion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTransaccion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_transaccion_sel';
		$this->transaccion='CONTA_TRANSA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_moneda','id_moneda','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_comprobante','int4');
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
		$this->captura('desc_partida','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_cuenta','text');
		$this->captura('desc_auxiliar','text');
		$this->captura('id_trans_val','int4');
		$this->captura('id_moneda','int4');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_transaccion_ime';
		$this->transaccion='CONTA_TRANSA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_transaccion_fk','id_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','varchar');
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_transaccion_ime';
		$this->transaccion='CONTA_TRANSA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_transaccion','id_transaccion','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_transaccion_fk','id_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','text');
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_transaccion_ime';
		$this->transaccion='CONTA_TRANSA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_transaccion','id_transaccion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>