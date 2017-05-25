<?php
/**
*@package pXP
*@file gen-MODGrupoOtDet.php
*@author  (admin)
*@date 06-10-2014 14:44:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODGrupoOtDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarGrupoOtDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_grupo_ot_det_sel';
		$this->transaccion='CONTA_GOTD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_grupo_ot_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('id_grupo_ot','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_orden','varchar');
		$this->captura('motivo_orden','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarGrupoOtDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_grupo_ot_det_ime';
		$this->transaccion='CONTA_GOTD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_grupo_ot','id_grupo_ot','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarGrupoOtDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_grupo_ot_det_ime';
		$this->transaccion='CONTA_GOTD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_grupo_ot_det','id_grupo_ot_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_grupo_ot','id_grupo_ot','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarGrupoOtDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_grupo_ot_det_ime';
		$this->transaccion='CONTA_GOTD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_grupo_ot_det','id_grupo_ot_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>