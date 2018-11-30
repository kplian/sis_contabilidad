<?php
/**
 *@package pXP
 *@file gen-MODContratoFactura.php
 *@author  (m.mamani)
 *@date 19-09-2018 13:16:55
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODContratoFactura extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarContratoFactura(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_contrato_factura_sel';
        $this->transaccion='CONTA_CCF_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_contrato','int4');
        $this->captura('id_gestion','int4');
        $this->captura('id_proceso_wf','int4');
        $this->captura('nro_tramite','varchar');
        $this->captura('tipo','varchar');
        $this->captura('objeto','text');
        $this->captura('desc_proveedor','varchar');
        $this->captura('bancarizacion','varchar');
        $this->captura('fecha_fin','date');
        $this->captura('fecha_inicio','date');
        $this->captura('desc_funcionario','text');
        $this->captura('numero_contrato','varchar');
        $this->captura('codigo_aux','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarContratoFactura(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_contrato_factura_ime';
        $this->transaccion='CONTA_CCF_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('objeto','objeto','text');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('bancarizacion','bancarizacion','varchar');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('desc_proveedor','desc_proveedor','varchar');
        $this->setParametro('fecha_inicio','fecha_inicio','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarContratoFactura(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_contrato_factura_ime';
        $this->transaccion='CONTA_CCF_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_contrato','id_contrato','int4');
        $this->setParametro('objeto','objeto','text');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('bancarizacion','bancarizacion','varchar');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('desc_proveedor','desc_proveedor','varchar');
        $this->setParametro('fecha_inicio','fecha_inicio','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarContratoFactura(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_contrato_factura_ime';
        $this->transaccion='CONTA_CCF_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_contrato','id_contrato','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>