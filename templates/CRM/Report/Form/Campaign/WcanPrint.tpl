<div id='crm-container'>
{foreach from=$rows item=row key=rowid}{assign var=count value=$count+1}

<div style="page-break-after: always"><div id="report-date"><p>Printed {$reportDate}</p></div>
<p><h1>{$row.civicrm_value_source_details_custom_126} - 
{$row.civicrm_contact_display_name}</h1><p>
{if $row.pledge_type eq 'Charge'}
<table class='report-layout'><tr><th>Last pledge was made by charge<th><tr><tr><th><th><tr></table>{/if}
<br>
<table class='report-layout'>
<tr><td>Member ID</td><td>{$row.civicrm_contact_id}</td><td>Turf Type</td>
       <th class='report-contents'>{$row.civicrm_value_source_details_custom_126}</th>
      </tr><tr>
      <tr>
       <td>Name</td>
       <td> {$row.civicrm_contact_display_name}{if $row.civicrm_contact_nick_name}   '{$row.civicrm_contact_nick_name}' {/if}</td> 
       <td>Group</td><td>{$row.civicrm_group_group_name}</td>
      </tr><tr>
      <tr>
      <td>Gender</td>
      <td> {$row.civicrm_contact_gender_id}</td>
      <td>Phone</td><td>{$row.civicrm_phone_phone} </td> 
     </tr>
      
     <tr>
      <td>Partner</td>
      <td> {$row.civicrm_contact_related_related_sort_name}{if $row.civicrm_related_contact_nick_name}   '{$row.civicrm_related_contact_nick_name}' {/if}</td> 
      <td>Best Time To Call</td><td>{$row.civicrm_value_source_details_custom_63}</td></tr>
      <td>Partner Gender</td>
      <td> {$row.civicrm_contact_related_gender_id}</td>  
      <td>Member Start Date</td><td>{$row.civicrm_value_core_info_custom_18|date_format}</td>           
     </tr>
<tr>      <td>Email </td>
      <td> {$row.civicrm_email_email} </td> 
     <td> Address</td>
      <td>{$row.civicrm_address_street_number} {$row.civicrm_address_street_unit} {$row.civicrm_address_street_name}<br>
        {$row.civicrm_address_city} {$row.civicrm_address_postal_code}
        
       </td>
 
           
       </tr>     
      </table>

{assign var=charge value =0} 

<br>
<br>
<h2>Notes</h2> 
{$row.civicrm_value_communication_details_custom_157}
<br>
<br>
<h2>Latest Pledges</h2>
<table class='report-layout'><tr>

<th>Committed on</th>
<th>Amount</th>
<th>Amount Paid</th>
<th>Type</th>
<th>Status</th>
<th>Paid By</th>
<th>Installments</th>
<th>Campaign</th>
<th>Dept</th>
<th>Worker</th>
</tr>
{$row.civicrm_aggregate_pledge_pledges}
</table>


{if $row.civicrm_related_pledge_related_pledges}
<h2>Related Contact Pledges </h2>
<p>TODO - custom fields / amount paid are tricky to add here</p>
<table class='report-layout'><tr>

<th>Committed on</th>
<th>Amount</th>
<th>Type</th>
<th>Amount Paid</th>
<th>Paid By</th>
<th>Installments</th>
<th>Campaign</th>
<th>Dept</th></tr>
{assign var=pledges value=$row.pledge_related}
{foreach from=$pledges item=pledge key=plkey name=pledgesarr}
<tr>
{foreach from=$pledge item=pledgerow key=arr name=pledgeindiv}
{if $pledgerow eq 'Charge'}<th>{$pledgerow}</th>
{else}
<td>{$pledgerow}</td>{/if}
{/foreach}
</tr>
{/foreach}
</table>
{/if}

<hr>
</div>
{/foreach}
</div>
NOTES - currently only 1 phone - need many I think
No related pledges yet
No notes field yet
Sorted by Group & then segment - not by check yet