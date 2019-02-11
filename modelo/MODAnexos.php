<?php
/**
 *@package pXP
 *@file gen-MODAnexo.php
 *@author  (Manuel Guerra)
 *@date 30-07-2018 12:12:51
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODAnexos extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function ListarAnexos1(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_AUNE_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');

        $this->captura('periodo','int4');
        $this->captura('codigo_columna1','varchar');
        $this->captura('columna1','varchar');
        $this->captura('monto1','numeric');
        $this->captura('columna2','varchar');
        $this->captura('monto2','numeric');
        $this->captura('columna3','varchar');
        $this->captura('monto3','numeric');
        $this->captura('columna4','varchar');
        $this->captura('monto4','numeric');
        $this->captura('columna5','varchar');
        $this->captura('monto5','numeric');
        $this->captura('columna6','varchar');
        $this->captura('monto6','numeric');
        $this->captura('columna7','varchar');
        $this->captura('monto7','numeric');
        $this->captura('columna8','varchar');
        $this->captura('monto8','numeric');
        $this->captura('columna9','varchar');
        $this->captura('monto9','numeric');
        $this->captura('columna10','varchar');
        $this->captura('monto10','numeric');
        $this->captura('detalle','varchar');
        $this->captura('monto11','numeric');
        $this->captura('monto12','numeric');
        $this->captura('monto13','numeric');
        $this->captura('monto14','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarAnexos2(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_ANX_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');

        $this->captura('gestion','integer');
        $this->captura('codigo','varchar');
        $this->captura('ordern','integer');
        $this->captura('columna','varchar');
        $this->captura('periodo','integer');

        $this->captura('monto_a','numeric');
        $this->captura('monto_b','numeric');
        $this->captura('monto_c','numeric');
        $this->captura('monto_d','numeric');
        $this->captura('monto_e','numeric');
        $this->captura('monto_f','numeric');
        $this->captura('monto_g','numeric');
        $this->captura('monto_h','numeric');
        $this->captura('monto_i','numeric');

        $this->captura('monto_j','numeric');
        $this->captura('monto_k','numeric');
        $this->captura('monto_l','numeric');
        $this->captura('monto_m','numeric');
        $this->captura('monto_n','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarAnexos4(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_ANF_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');
        //gestion
        $this->captura('gestion','integer');
        $this->captura('codigo','varchar');
        $this->captura('ordern','integer');
        $this->captura('columna','varchar');
        $this->captura('periodo','integer');

        $this->captura('monto_a','numeric');
        $this->captura('monto_b','numeric');
        $this->captura('monto_c','numeric');
        $this->captura('monto_d','numeric');
        $this->captura('monto_e','numeric');
        $this->captura('monto_f','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarAnexos5(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_ANC_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');
        //gestion
        $this->captura('periodo','integer');
        $this->captura('saldo','numeric');
        $this->captura('it','numeric');
        $this->captura('operacion','numeric');
        $this->captura('tipo','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarAnexos6(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_AXV_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');
        //gestion
        $this->captura('gestion','integer');
        $this->captura('codigo','varchar');
        $this->captura('ordern','integer');
        $this->captura('columna','varchar');
        $this->captura('periodo','integer');

        $this->captura('monto_a','numeric');
        $this->captura('monto_b','numeric');
        $this->captura('monto_c','numeric');
        $this->captura('monto_d','numeric');
        $this->captura('monto_e','numeric');
        $this->captura('monto_f','numeric');
        $this->captura('monto_g','numeric');
        $this->captura('monto_h','numeric');
        $this->captura('monto_i','numeric');

        $this->captura('monto_j','numeric');
        $this->captura('monto_k','numeric');
        $this->captura('monto_l','numeric');
        $this->captura('monto_m','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarAnexos7(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_ANZ_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');
        //gestion
        $this->captura('codigo_columna','varchar');
        $this->captura('ordern','integer');
        $this->captura('columna','varchar');
        $this->captura('titulo','varchar');

        $this->captura('monto_a','numeric');
        $this->captura('monto_b','numeric');
        $this->captura('monto_c','numeric');
        $this->captura('monto_d','numeric');
        $this->captura('monto_e ','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
      // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarAnexos8(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_ANOC_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');

        $this->captura('titulo','varchar');
        $this->captura('nro_cuenta','varchar');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('motivo','varchar');
        $this->captura('normativa','varchar');
        $this->captura('importe','numeric');
        $this->captura('ordenar','integer');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarAnexos9(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_NINE_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');

        $this->captura('titulo','varchar');
        $this->captura('nro_cuenta','varchar');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('motivo','varchar');
        $this->captura('normativa','varchar');
        $this->captura('importe','numeric');
        $this->captura('ordenar','integer');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listaDetalleAux(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_AUD_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');

        $this->captura('periodo','integer');
        $this->captura('nro_cuenta','varchar');
        $this->captura('codigo_partida','varchar');
        $this->captura('titulo','varchar');
        $this->captura('importe','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarAnexos10(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_anexos_sel';
        $this->transaccion='CONTA_THE_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo_anexo','tipo_anexo','varchar');

        $this->captura('periodo','integer');
        $this->captura('monto','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }


}
?>















