<?php
/**
*@package pXP
*@file gen-MODTipoRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:51:43
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoRelacionContable extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoRelacionContable(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_tipo_relacion_contable_sel';
		$this->transaccion='CONTA_TIPRELCO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_relacion_contable','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre_tipo_relacion','varchar');
		$this->captura('tiene_centro_costo','varchar');
		$this->captura('codigo_tipo_relacion','varchar');
		$this->captura('id_tabla_relacion_contable','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tiene_partida','varchar');
		$this->captura('tiene_auxiliar','varchar');
		$this->captura('partida_tipo','varchar');
		$this->captura('partida_rubro','varchar');
		$this->captura('tiene_aplicacion','varchar');
		$this->captura('tiene_moneda','varchar');
		$this->captura('tiene_tipo_centro','varchar');
		$this->captura('codigo_aplicacion_catalogo','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_relacion_contable_ime';
		$this->transaccion='CONTA_TIPRELCO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre_tipo_relacion','nombre_tipo_relacion','varchar');
		$this->setParametro('tiene_centro_costo','tiene_centro_costo','varchar');
		$this->setParametro('codigo_tipo_relacion','codigo_tipo_relacion','varchar');
		$this->setParametro('id_tabla_relacion_contable','id_tabla_relacion_contable','int4');
		$this->setParametro('tiene_partida','tiene_partida','varchar');
		$this->setParametro('tiene_auxiliar','tiene_auxiliar','varchar');
		$this->setParametro('partida_tipo','partida_tipo','varchar');
		$this->setParametro('partida_rubro','partida_rubro','varchar');
		$this->setParametro('tiene_aplicacion','tiene_aplicacion','varchar');
		$this->setParametro('tiene_moneda','tiene_moneda','varchar');
		$this->setParametro('tiene_tipo_centro','tiene_tipo_centro','varchar');
		$this->setParametro('codigo_aplicacion_catalogo','codigo_aplicacion_catalogo','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_relacion_contable_ime';
		$this->transaccion='CONTA_TIPRELCO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_relacion_contable','id_tipo_relacion_contable','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre_tipo_relacion','nombre_tipo_relacion','varchar');
		$this->setParametro('tiene_centro_costo','tiene_centro_costo','varchar');
		$this->setParametro('codigo_tipo_relacion','codigo_tipo_relacion','varchar');
		$this->setParametro('id_tabla_relacion_contable','id_tabla_relacion_contable','int4');
		$this->setParametro('tiene_partida','tiene_partida','varchar');
		$this->setParametro('tiene_auxiliar','tiene_auxiliar','varchar');
		$this->setParametro('partida_tipo','partida_tipo','varchar');
		$this->setParametro('partida_rubro','partida_rubro','varchar');
		$this->setParametro('tiene_aplicacion','tiene_aplicacion','varchar');
		$this->setParametro('tiene_moneda','tiene_moneda','varchar');
		$this->setParametro('tiene_tipo_centro','tiene_tipo_centro','varchar');
		$this->setParametro('codigo_aplicacion_catalogo','codigo_aplicacion_catalogo','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_relacion_contable_ime';
		$this->transaccion='CONTA_TIPRELCO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_relacion_contable','id_tipo_relacion_contable','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>