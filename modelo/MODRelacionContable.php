<?php
/**
*@package pXP
*@file gen-MODRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:52:14
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRelacionContable extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRelacionContable(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_relacion_contable_sel';
		$this->transaccion='CONTA_RELCON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_relacion_contable','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_tipo_relacion_contable','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_tabla','int4');
		$this->captura('gestion','int4');
		$this->captura('nombre_tipo_relacion','varchar');
		
		$this->captura('nro_cuenta','varchar');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');
		$this->captura('codigo_partida','varchar');
		$this->captura('nombre_partida','varchar');
		
		$this->captura('tiene_centro_costo','varchar');
		$this->captura('tiene_partida','varchar');
		$this->captura('tiene_auxiliar','varchar');
		$this->captura('codigo_cc','text');
		$this->captura('defecto','varchar');
		$this->captura('partida_tipo','varchar');
		$this->captura('partida_rubro','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_relacion_contable_ime';
		$this->transaccion='CONTA_RELCON_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_relacion_contable','id_tipo_relacion_contable','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_tabla','id_tabla','int4');
		$this->setParametro('defecto','defecto','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_relacion_contable_ime';
		$this->transaccion='CONTA_RELCON_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_relacion_contable','id_relacion_contable','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_relacion_contable','id_tipo_relacion_contable','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_tabla','id_tabla','int4');
		$this->setParametro('defecto','defecto','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRelacionContable(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_relacion_contable_ime';
		$this->transaccion='CONTA_RELCON_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_relacion_contable','id_relacion_contable','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function clonarConfig(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_relacion_contable_ime';
		$this->transaccion='CONTA_REPRELCON_REP';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_relacion_contable','id_relacion_contable','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	 function getDlbXDconta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_relacion_contable_ime';
		$this->transaccion='CONTA_GDLB_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_depto_conta','id_depto_conta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>