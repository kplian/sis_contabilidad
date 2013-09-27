<link rel="stylesheet" href="../../lib/lib_reporte/smarty/styles/ksmarty.css">
<table border="1" cellspacing="0" cellpadding="0" width="100%">
	{foreach from=$transac item=tra}
		<tr>
			<td width="50%">
				<b>CC:</b> {$tra['cc']} <b>Ptda.:</b> {$tra['partida']}<br>
	   			<b>Cta.:</b> {$tra['cuenta']}<br>
	   			<b>Aux.:</b> {$tra['auxiliar']}
			</td>
			<td width="10%" class="td_currency"><span>{$tra['ejecucion_bs']}</span></td>
			<td width="10%" class="td_currency"><span>{$tra['importe_debe1']}</span></td>
			<td width="10%" class="td_currency"><span>{$tra['importe_haber1']}</span></td>
			<td width="10%" class="td_currency"><span>{$tra['importe_debe']}</span></td>
			<td width="10%" class="td_currency"><span>{$tra['importe_haber']}</span></td>
		</tr>
	{/foreach}
	<tr>
		<td width="50%" align="right"><b>TOTALES</b></td>
		<td width="10%" class="td_currency"><span><b>{$tot_ejecucion_bs}</b></span></td>
		<td width="10%" class="td_currency"><span><b>{$tot_importe_debe1}</b></span></td>
		<td width="10%" class="td_currency"><span><b>{$tot_importe_haber1}</b></span></td>
		<td width="10%" class="td_currency"><span><b>{$tot_importe_debe}</b></span></td>
		<td width="10%" class="td_currency"><span><b>{$tot_importe_haber}</b></span></td>
	</tr>
</table>