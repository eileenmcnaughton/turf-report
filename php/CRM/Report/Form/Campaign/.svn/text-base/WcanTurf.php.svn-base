<?php

/*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.0                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2011                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*/

/**
 *
 * @package CRM
 * @copyright CiviCRM LLC (c) 2004-2011
 * $Id$
 *
 */

require_once 'CRM/Report/Form.php';
require_once 'CRM/Campaign/BAO/Survey.php';

class CRM_Report_Form_Campaign_WcanTurf extends CRM_Report_Form {
    
    protected $_emailField   = false;
    
    protected $_phoneField   = false;
    
    protected $_summary      = null;
    protected $_customGroupGroupBy = true;   
    protected $_customGroupExtends = array( 'Contact', 'Individual', 'Household', 'Organization', 'Activity' , 'Pledge');
    
    private static $_surveyRespondentStatus;

    function __construct( ) {
        
        //filter options for survey activity status.
        $responseStatus = array( );
        self::$_surveyRespondentStatus = array( );
        require_once 'CRM/Core/PseudoConstant.php';
        $activityStatus = CRM_Core_PseudoConstant::activityStatus( 'name' );
        if ( $statusId = array_search( 'Scheduled', $activityStatus ) ) {
            $responseStatus[$statusId] = ts( 'Reserved' );
            self::$_surveyRespondentStatus[$statusId] = 'Reserved';
        }
        if ( $statusId = array_search( 'Completed', $activityStatus ) ) {
            $responseStatus[$statusId] = ts( 'Interviewed' );
            self::$_surveyRespondentStatus[$statusId] = 'Interviewed';
        }
        
        //get all interviewers.
        $allSurveyInterviewers = CRM_Campaign_BAO_Survey::getInterviewers( );
        
        $this->_columns = 
            array( 'civicrm_activity_assignment' => 
                   array( 'dao'       => 'CRM_Activity_DAO_ActivityAssignment',
                          'fields'    =>  array( 'assignee_contact_id' => array( 'title' => ts( 'Interviewer Name' ) ) ),
                          'filters'   =>  array( 'assignee_contact_id' => array( 'name'   => 'assignee_contact_id',
                                                                                 'title'  => ts( 'Interviewer Name' ),
                                                                                 'type'          => CRM_Utils_Type::T_INT,
                                                                                 'operatorType'  => 
                                                                                 CRM_Report_Form::OP_SELECT,
                                                                                 'options' => array( '' => ts( '- any interviewer -' ) ) + $allSurveyInterviewers ) ),
                          'grouping'  => 'survey-interviewer-fields',
                          ),
                   
                   'civicrm_contact'  =>
                   array( 'dao'       => 'CRM_Contact_DAO_Contact',
                          'fields'    =>  array( 'id'           => array( 'title'       => ts( 'Contact ID' ),
                                                                          'no_display'  => true, 
                                                                          'required'    => true),  
                                                 'sort_name' => array( 'title'       => ts( 'Respondent Name' ),
                                                                       'required'    => true,
                                                                       'no_repeat'   => true ),
                                                
                                                 'nick_name' => array( 'title'       => ts( 'Nick Name*' ),
                                                                       'required'    => true,
                                                                       'no_repeat'   => false),
                                                 'display_name' => array( 'title'       => ts( 'Display Name' ),
                                                                       'required'    => true,
                                                                       'no_repeat'   => false),
                                                 'gender_id' => array( 'title'       => ts( 'Gender' ),
                                                                       'required'    => true,
                                                                       'no_repeat'   => false),
                                                 
                                                 ),
                         
                          'filters'   =>  array('sort_name'     => array( 'title'       => ts( 'Respondent Name' ),
                                                                          'operator'    => 'like' ) ),
                          'grouping'  => 'contact-fields',
                          'order_bys' => array( 'sort_name'  => array( 'title'       => ts( 'Respondent Name' ),
                                                                       'required'    => true ) ),
                          ),
                  'civicrm_aggregate_pledge' => 
                  array('dao'       => 'CRM_Pledge_DAO_Pledge',
                        'fields'    =>
                        array('pledges'         =>
                              array( 'no_display'=> false,
                                     'required'  => true,
                                     'title' => 'Pledges' ),),
                               'amount_paid'         =>
                              array( 'no_display'=> false,
                                     'required'  => true,
                            
                                     'title' => 'Amount Paid' ),),
                 'civicrm_pledge'  =>
                  array('dao'       => 'CRM_Pledge_DAO_Pledge',
                        'fields'    =>
                        array('id'         =>
                              array( 'no_display'=> true,
                                     'required'  => true,
                                     'name' => 'id',
                                     'title' => 'Latest Pledge ID' ),
                              
                             
                              'amount'     =>
                              array( 'title'     => ts('Latest Pledge Amount'),
                                     'required'  => true,
                                     'type'      => CRM_Utils_Type::T_MONEY, 
                               ),
                              'frequency_unit'=>
                              array( 'title'=> ts('Latest Frequency Unit'),),
                              
                              'installments'=>
                              array( 'title'=> ts('Latest Installments' ), 
                                      'required'  => true,),
                              
                              'pledge_create_date' =>
                              array( 'title'=> ts('Latest Pledge Made Date'),
                                     'required'  => true, ),                                        

                              'start_date'  =>
                              array( 'title'=> ts('Latest Pledge Start Date'),
                                     'type' => CRM_Utils_Type::T_DATE ,
                                     'required'  => true,),
                              
                              
                              'end_date'    =>   
                              array( 'title'=> ts('Latest Pledge End Date'),
                                     'type' => CRM_Utils_Type::T_DATE ),
                              
                              'status_id'   =>
                              array( 'title'   => ts('Latest Pledge Status'),
                                                                 ),
                              
                                                          
                             'contribution_type_id'  =>
                              array( 'title'   => ts('Latest Contribution Type'),
                              					'required'  => true, ),

                                    
                              
                              ),
                  ),
                 'civicrm_related_pledge'  =>
                  array('dao'       => 'CRM_Pledge_DAO_Pledge',
                        'alias'			=> 'related_pledge',
                        'fields'    =>
                        array('related_pledges'         =>
                              array( 'no_display'=> false,
                                     'required'  => true,
                                     'name' => 'id',
                                     'title' => 'Related Contact Pledges' ),
                              
                             
                              'related_amount'     =>
                              array( 'title'     => ts('Related Contact Pledge Amount'),
                                     'required'  => true,
                                     'type'      => CRM_Utils_Type::T_MONEY, 
                                     'name'			=> 'amount',
                               ),
                             
                              'related_installments'=>
                              array( 'title'=> ts('Related Contact Installments' ), 
                                      'required'  => true,
                                      'name'			=> 'installments',),
                              
                              'related_pledge_create_date' =>
                              array( 'title'=> ts('Related Contact Pledge Made Date'),
                                     'required'  => true,
                                      'name'			=> 'create_date', ),                                        

                              'related_start_date'  =>
                              array( 'title'=> ts('Related Contact Pledge Start Date'),
                                     'type' => CRM_Utils_Type::T_DATE ,
                                     'required'  => true,
                                     'name'			=> 'start_date', ),   ),
                              
                              
                              'related_end_date'    =>   
                              array( 'title'=> ts('Related Contact Pledge End Date'),
                                     'type' => CRM_Utils_Type::T_DATE,
                                      'name'			=> 'end_date', ),
                              
                              'related_status_id'   =>
                              array( 'title'   => ts('Related Contact Pledge Status'),
                                            'name'			=> 'status_id',                      
                                     ),
                              
                                                          
                             'related_contribution_type_id'  =>
                              array( 'title'   => ts('Related Contact Contribution Type'),
                              					'required'  => true,
                                        'name'		=> 'contribution_type_id' 
                              ),
                                    
                              
                  ),
    
                  'civicrm_contact_related'  =>
                   array( 'dao'       => 'CRM_Contact_DAO_Contact',
                          'alias'			=> 'related_contact' ,
                          'fields'    =>  array( 
                                                 'related_sort_name' => array( 'title'       => ts( 'Related Contact' ),
                                                                       'required'    => true,
                                                                       'no_repeat'   => true ,
                   																										 'name'      => 'sort_name',
                                                                  
                                                                 ),
                                                 'nick_name' => array( 'title'       => ts( 'Related Contact Nick Name' ),
                                                                       'required'    => true,
                                                                       'no_repeat'   => false),
                                                 'gender_id' => array( 'title'       => ts( 'Related Contact Gender' ),
                                                                       'required'    => true,
                                                                       'no_repeat'   => false),
                                                

                                                 ),
                          'filters'   =>  array('sort_name'     => array( 'title'       => ts( 'Respondent Name' ),
                                                                          'operator'    => 'like' ) ),
                          'grouping'  => 'contact-fields',
                          'order_bys' => array( 'sort_name'  => array( 'title'       => ts( 'Respondent Name' ),
                                                                       'required'    => true ) ),
                          ),                  
                   'civicrm_phone'    => 
                   array( 'dao'       => 'CRM_Core_DAO_Phone',
                          'fields'    => array( 'phone'         =>  array( 'name'       => 'phone',
                                                                           'title'      => ts( 'Phone' ) ) ),
                          'grouping'  => 'location-fields',
                          ),
                   
                   'civicrm_address'  =>
                   array( 'dao'       => 'CRM_Core_DAO_Address',
                          'fields'    => array( 'street_number'     => array( 'name'  => 'street_number',
                                                                              'title' => ts( 'Street Number' ),
                                                                              'type'  => 1 ),
                                                'street_name'       => array( 'name'  => 'street_name',
                                                                              'title' => ts( 'Street Name' ),
                                                                              'type'  => 1 ),
                                                'street_unit'       => array( 'name'  => 'street_unit',
                                                                              'title' => ts( 'Street Unit' ),
                                                                              'type'  => 1 ),
                                                'postal_code'       => array( 'name'  => 'postal_code',
                                                                              'title' => ts( 'Postal Code' ),
                                                                              'type'  => 1 ),
                                                'city'              => array( 'name'  => 'city',
                                                                              'title' => ts( 'City' ),
                                                                              'type'  => 1 ),
                                                'state_province_id' => array( 'name'    => 'state_province_id',
                                                                              'title'   => ts( 'State/Province' ) ),
                                                'country_id'        => array( 'name'    => 'country_id',
                                                                              'title'   => ts( 'Country' ) ) ),
                          'filters'   =>   array( 'street_number'   => array( 'title'   => ts( 'Street Number' ),
                                                                              'type'    => 1,
                                                                              'name'    => 'street_number' ),
                                                  'street_name'     => array( 'title'    => ts( 'Street Name' ),
                                                                              'name'     => 'street_name',
                                                                              'operator' => 'like' ),
                                                  'postal_code'     => array( 'title'   => ts( 'Postal Code' ),
                                                                              'type'    => 1,
                                                                              'name'    => 'postal_code' ),
                                                  'city'            => array( 'title'   => ts( 'City' ),
                                                                              'operator' => 'like',
                                                                              'name'    => 'city' ),
                                                  'state_province_id' =>  array( 'name'  => 'state_province_id',
                                                                                 'title' => ts( 'State/Province' ), 
                                                                                 'operatorType' => 
                                                                                 CRM_Report_Form::OP_MULTISELECT,
                                                                                 'options'       => 
                                                                                 CRM_Core_PseudoConstant::stateProvince()), 
                                                  'country_id'        =>  array( 'name'         => 'country_id',
                                                                                 'title'        => ts( 'Country' ), 
                                                                                 'operatorType' => 
                                                                                 CRM_Report_Form::OP_MULTISELECT,
                                                                                 'options'       => 
                                                                                 CRM_Core_PseudoConstant::country( ) ) ),
                          'group_bys' =>   array( 'street_name'       =>  array( 'title' => ts('Street Name') ),
                                                  'street_number'     =>  array( 'title' => 'Odd / Even Street Number' ) ),
                          
                          'order_bys' =>   array( 'street_name'       => array( 'title'   => ts( 'Street Name' ) ),
                                                  'street_number'     => array( 'title'   => 'Odd / Even Street Number' ) ),
                          
                          'grouping'  => 'location-fields',
                          ),
                   
                   'civicrm_email'    => 
                   array( 'dao'       => 'CRM_Core_DAO_Email',
                          'fields'    =>  array( 'email' => array( 'name' => 'email',
                                                                   'title' => ts( 'Email' ) ) ),
                          'grouping'  => 'location-fields',
                          ),
                   'civicrm_group'    => 
                   array( 'dao'       => 'CRM_Contact_DAO_Group',
                          'fields'    =>  array( 'group_name' => array( 'name' => 'title',
                                                                   'title' => ts( 'Group' ) ) ),
                          'grouping'  => 'location-fields',
                          ),
                                      
                   'civicrm_activity' =>
                   array( 'dao'       => 'CRM_Activity_DAO_Activity',
                          'alias'     => 'survey_activity',
                          'fields'    => array( 'survey_id'        => array( 'name'         => 'source_record_id',
                                                                             'title'        => ts( 'Survey' ),
                                                                             'type'         => CRM_Utils_Type::T_INT,
                                                                             'operatorType' => 
                                                                             CRM_Report_Form::OP_MULTISELECT,
                                                                             'options'      => 
                                                                             CRM_Campaign_BAO_Survey::getSurveys( ) ),
                                                                    ),

                          'filters'   => array( 'survey_id' => array( 'name'         => 'source_record_id',
                                                                      'title'        => ts( 'Survey' ),
                                                                      'type'         => CRM_Utils_Type::T_INT,
                                                                      'operatorType' => CRM_Report_Form::OP_MULTISELECT,
                                                                      'options'      => 
                                                                      CRM_Campaign_BAO_Survey::getSurveys( ) ) ,
                                                'status_id' => array( 'name'          => 'status_id',
                                                                      'title'         => ts( 'Respondent Status' ), 
                                                                      'type'          => CRM_Utils_Type::T_INT,
                                                                      'operatorType'  => CRM_Report_Form::OP_SELECT,
                                                                      'options'       => $responseStatus ) ),
                          'grouping' => 'survey-activity-fields',
                          ),
                   
                   );
        
        parent::__construct( );
    }
    
    function preProcess( ) {
        parent::preProcess( );
    }
    
    function select( ) {
        parent::select();
    }
    
    function from( ) {
        $this->_from = " FROM civicrm_contact {$this->_aliases['civicrm_contact']} {$this->_aclFrom} ";
        static $tempPayments ;
        if(empty($tempPayments)){
           $tempPayments = $this->_create_temp_payments_table();
        }
        //get the activity table joins.
        $this->_from .= " INNER JOIN civicrm_activity_target ON ( {$this->_aliases['civicrm_contact']}.id = civicrm_activity_target.target_contact_id )\n";
        $this->_from .= " INNER JOIN civicrm_activity {$this->_aliases['civicrm_activity']} ON ( {$this->_aliases['civicrm_activity']}.id = civicrm_activity_target.activity_id )\n";
        $this->_from .= " INNER JOIN civicrm_activity_assignment {$this->_aliases['civicrm_activity_assignment']} ON ( {$this->_aliases['civicrm_activity']}.id = {$this->_aliases['civicrm_activity_assignment']}.activity_id )\n";
        $this->_from .= " LEFT JOIN civicrm_relationship rel  ON ({$this->_aliases['civicrm_contact']}.id = rel.contact_id_a AND rel.is_active = 1 AND (rel.start_date < NOW() OR rel.start_date IS NULL) AND (rel.end_date > NOW() OR rel.end_date IS NULL))";  
        $this->_from .= " LEFT JOIN civicrm_contact {$this->_aliases['civicrm_contact_related']}  ON {$this->_aliases['civicrm_contact_related']}.id = rel.contact_id_b";
        $this->_from .= " LEFT JOIN civicrm_group_contact gc  ON {$this->_aliases['civicrm_contact']}.id = gc.contact_id AND gc.status = 'Added'";
        $this->_from .= " LEFT JOIN civicrm_group {$this->_aliases['civicrm_group']}  ON {$this->_aliases['civicrm_group']}.id = gc.group_id";
        $this->_from .= " LEFT JOIN " .  $this->_create_temp_pledges_table() . " as {$this->_aliases['civicrm_aggregate_pledge']} on 
                  {$this->_aliases['civicrm_aggregate_pledge']}.contact_id = {$this->_aliases['civicrm_contact']}.id";
        $this->_from .= " LEFT JOIN civicrm_pledge as {$this->_aliases['civicrm_pledge']} on 
                  {$this->_aliases['civicrm_pledge']}.id = {$this->_aliases['civicrm_aggregate_pledge']}.latest_pledge_id";                 
        $this->_from .= " LEFT JOIN civicrm_pledge {$this->_aliases['civicrm_related_pledge']}  ON {$this->_aliases['civicrm_related_pledge']}.contact_id = {$this->_aliases['civicrm_contact_related']}.id ";
        //get the address table.
        $this->_from .= " LEFT JOIN civicrm_address {$this->_aliases['civicrm_address']} ON {$this->_aliases['civicrm_contact']}.id = {$this->_aliases['civicrm_address']}.contact_id AND {$this->_aliases['civicrm_address']}.is_primary = 1\n";
        
        if ( $this->_emailField ) {
            $this->_from .= "LEFT JOIN civicrm_email {$this->_aliases['civicrm_email']} ON {$this->_aliases['civicrm_contact']}.id = {$this->_aliases['civicrm_email']}.contact_id AND {$this->_aliases['civicrm_email']}.is_primary = 1\n";
        }
        
        if ( $this->_phoneField ) {
            $this->_from .= "LEFT JOIN ". $this->_create_temp_phones_table('<br>') . " {$this->_aliases['civicrm_phone']} ON {$this->_aliases['civicrm_contact']}.id = {$this->_aliases['civicrm_phone']}.contact_id \n";
        }
    }
    
    function where( ) {
        $clauses = array( );
        foreach ( $this->_columns as $tableName => $table ) {
            if ( array_key_exists('filters', $table) ) {
                foreach ( $table['filters'] as $fieldName => $field ) {
                    $clause = null;
                    
                    if ( CRM_Utils_Array::value('type', $field) & CRM_Utils_Type::T_DATE ) {
                        $relative = CRM_Utils_Array::value( "{$fieldName}_relative", $this->_params );
                        $from     = CRM_Utils_Array::value( "{$fieldName}_from"    , $this->_params );
                        $to       = CRM_Utils_Array::value( "{$fieldName}_to"      , $this->_params );
                        
                        $clause = $this->dateClause( $field['name'], $relative, $from, $to, $field['type'] );
                    } else {
                        $op = CRM_Utils_Array::value( "{$fieldName}_op", $this->_params );
                        if ( $op ) {
                            $clause = 
                                $this->whereClause( $field,
                                                    $op,
                                                    CRM_Utils_Array::value( "{$fieldName}_value", $this->_params ),
                                                    CRM_Utils_Array::value( "{$fieldName}_min", $this->_params ),
                                                    CRM_Utils_Array::value( "{$fieldName}_max", $this->_params ) );
                        }
                    }
                    
                    if ( ! empty( $clause ) ) {
                        $clauses[] = $clause;
                    }
                }
            }
        }
        
        //apply survey activity types filter.
        $surveyActivityTypes = CRM_Campaign_BAO_Survey::getSurveyActivityType( );
        if ( !empty( $surveyActivityTypes ) ) {
            $clauses[] = "( {$this->_aliases['civicrm_activity']}.activity_type_id IN ( ". 
                implode( ' , ', array_keys(  $surveyActivityTypes ) ) . ' ) )';
        }
        
        // always filter out deleted activities (so contacts that have been released
        // don't show up in the report).
        $clauses[] = "( {$this->_aliases['civicrm_activity']}.is_deleted = 0 )";

        if ( empty( $clauses ) ) {
            $this->_where = "WHERE ( 1 ) ";
        } else {
            $this->_where = "WHERE " . implode( ' AND ', $clauses );
        }
        
        if ( $this->_aclWhere ) {
            $this->_where .= " AND {$this->_aclWhere} ";
        }
    }
    
    function groupBy( ) {
        $this->_groupBy = null;
        if ( CRM_Utils_Array::value('group_bys', $this->_params) &&
             is_array( $this->_params['group_bys'] ) ) {
            foreach ( $this->_columns as $tableName => $table ) {
                if ( array_key_exists('group_bys', $table) ) {
                    foreach ( $table['group_bys'] as $fieldName => $field ) {
                        if ( !in_array( $fieldName, array( 'street_name', 'street_number' ) ) && 
                             CRM_Utils_Array::value( $fieldName, $this->_params['group_bys'] ) ) {
                            $this->_groupBy[] = $field['dbAlias'];
                        }
                    }
                }
            }
        }
        if ( is_array( $this->_groupBy ) && !empty( $this->_groupBy ) ) {
            $this->_groupBy = ' GROUP BY ' . implode( ', ', $this->_groupBy );
        }
    }
    
    function orderBy( ) {
        $this->_orderBy = null;
        
        //group by as per street name and odd/even street number.
        $groupBys = CRM_Utils_Array::value( 'group_bys', $this->_params, array( ) );
        
        $specialOrderFields = array( 'street_name', 'street_number' );
        $hasSpecialGrouping = false;
        foreach ( $specialOrderFields as $fldName ) {
            if ( CRM_Utils_Array::value( $fldName, $groupBys ) ) {
                $field = CRM_Utils_Array::value( $fldName, $this->_columns['civicrm_address']['group_bys'], array( ) );
                if ( $fldName == 'street_number' ) {
                    $this->_orderBy[] = "{$field['dbAlias']}%2";
                    $this->_orderBy[] = "{$field['dbAlias']}";
                    $hasSpecialGrouping = true;
                } else {
                    $this->_orderBy[] = "{$field['dbAlias']}";
                    $hasSpecialGrouping = true;
                }
            }
        }
        
        //in case of special grouping, lets bypass all orders.
        if ( ! $hasSpecialGrouping ) {
            foreach ( $this->_columns as $tableName => $table ) {
                if ( array_key_exists('order_bys', $table) ) {
                    foreach ( $table['order_bys'] as $fieldName => $field ) {
                        if ( !in_array( $fieldName, $specialOrderFields ) ) {
                            $this->_orderBy[] = $field['dbAlias'];
                        }
                    }
                }
            }
        }
     $this->_orderBy = array('civicrm_group_group_name',
                             'civicrm_value_source_details_custom_126',
                             'civicrm_value_pledge_data_27_custom_111',
                             'civicrm_pledge_amount',
                             'civicrm_pledge_pledge_create_date DESC');
    if ( is_array( $this->_orderBy ) && !empty( $this->_orderBy ) ) {
            $this->_orderBy[] = " {$this->_aliases['civicrm_activity']}.id desc ";
            $this->_orderBy = "ORDER BY " . implode( ', ', $this->_orderBy ) . " ";
        }
    }
    
    function postProcess( ) {
       
        //generic code
        $this->beginPostProcess( );
        $sql = $this->buildQuery( );
        $this->buildRows ( $sql, $rows );
        $this->formatDisplay( $rows );
        
        // we'll output the pledges in a table for the onscreen format but as just rows for the print / pdf format
        // so we can add headers to in for print & pdf & not onscreen
        $pledgeStart = "";
        $pledgeEnd = "";
         if ( !in_array( $this->_outputMode, array( 'print', 'pdf' ) ) ) {  
           $pledgeStart = "<table>";
           $pledgeEnd   = "</table>";
         }       
        require_once 'CRM/Contribute/PseudoConstant.php';
        $contributionTypes = CRM_Contribute_PseudoConstant::contributionType( );
        $contactRows = array();// we are going to re-work this into a contact indexed array - see notes below - the reason for this 
                               // has been mostly removed
        foreach ( $rows as $rowNum => $row ) {
                if ( array_key_exists('civicrm_contact_gender_id', $row) ) {
                if ( $value = $row['civicrm_contact_gender_id'] ) {
                    $gender=CRM_Core_PseudoConstant::gender();
                    $rows[$rowNum]['civicrm_contact_gender_id'] =$gender[$value];
                }       
                }
                if ( array_key_exists('civicrm_contact_related_gender_id', $row) ) {
                if ( $value = $row['civicrm_contact_related_gender_id'] ) {
                    $gender=CRM_Core_PseudoConstant::gender();
                    $rows[$rowNum]['civicrm_contact_related_gender_id'] =$gender[$value];
                }       
                }
                if ( $value = CRM_Utils_Array::value( 'civicrm_pledge_contribution_type_id', $row ) ) {
                  $rows[$rowNum]['civicrm_pledge_contribution_type_id'] = $contributionTypes[$value];

               }
        //This section consolidates the rows by contact ID. Apart from the related contact pledges side it is probably redundant now
        // as I changed the SQL to generate a unique row per contact.
        // However, would still get multiple rows if the related contact had multiple pledges
        // TODO related pledge is calculated via php rather than SQL - I was doing both like this but it was too intensive
        // so I made mysql do the work but since I'm using a temp table I can't join on it twice. Hence related pledges 
        // return less data & are still intensive (although for our use there tend to be few of them).
        // ideally probably the table would not be temp for this reason (but would be dropped afterwards)
        if(empty($contactRows[$row['civicrm_contact_id']]['no_pledges'])){
                  $contactRows[$row['civicrm_contact_id']] = $rows[$rowNum];
                  $contactRows[$row['civicrm_contact_id']]['pledge'][$row['civicrm_pledge_pledges']] = $this->_compile_pledge($rows[$rowNum],$contactRows,'array');   

                  $contactRows[$row['civicrm_contact_id']]['pledge_related'][$row['civicrm_related_pledge_related_pledges']] = $this->_compile_pledge($rows[$rowNum],$contactRows,'array',1);
 
                  $contactRows[$row['civicrm_contact_id']]['civicrm_aggregate_pledge_pledges'] =  $pledgeStart. $rows[$rowNum]['civicrm_aggregate_pledge_pledges'].  $pledgeEnd;
                  $contactRows[$row['civicrm_contact_id']]['no_pledges'] = 1;
                  //TODO hard coded custom field - remove - this can be moved to tpl
                  //
                  $contactRows[$row['civicrm_contact_id']]['pledge_type'] = $row["civicrm_value_pledge_data_27_custom_111"];
        }else{  
          if ($contactRows[$row['civicrm_contact_id']]['no_pledges'] < 5){
            $contactRows[$row['civicrm_contact_id']]['pledge'][$row['civicrm_pledge_id']] = $this->_compile_pledge($rows[$rowNum],$contactRows,'array');   
          } 
          $contactRows[$row['civicrm_contact_id']]['no_pledges'] += 1;
        }
        }
        if ( in_array( $this->_outputMode, array( 'print', 'pdf' ) ) ) {        

            $outPut       = array( );
            $templateFile = 'CRM/Report/Form/Campaign/WcanPrint.tpl';

                $this->doTemplateAssignment( $contactRows);
                $outPut[] = CRM_Core_Form::$_template->fetch( $templateFile );
            
            
            $header = $this->_formValues['report_header'];
            $footer = $this->_formValues['report_footer'];
 
            
            $outPut = 
                $header . 
                implode( $footerImage . 
                         "<div style=\"page-break-after: always\"></div>",
                         $outPut ) . 
                $footer;
            
            if ( $this->_outputMode == 'print' ) {
                echo $outPut ;
            } else {
                require_once 'CRM/Utils/PDF/Utils.php';                     
                CRM_Utils_PDF_Utils::html2pdf( $outPut, "CiviReport.pdf" );
            }
            
            CRM_Utils_System::civiExit( );
        } else {
            $this->doTemplateAssignment( $contactRows);
            $this->endPostProcess( $contactRows );
        }
    }
    

    
    function alterDisplay( &$rows ) {

        
       
        // custom code to alter rows
        $entryFound = false;
        foreach ( $rows as $rowNum => $row ) { 
            // handle state province
            if ( array_key_exists('civicrm_address_state_province_id', $row) ) {
                if ( $value = $row['civicrm_address_state_province_id'] ) {
                    $rows[$rowNum]['civicrm_address_state_province_id'] = 
                        CRM_Core_PseudoConstant::stateProvince( $value );
                }
                $entryFound = true;
            }
            
            // handle country
            if ( array_key_exists('civicrm_address_country_id', $row) ) {
                if ( $value = $row['civicrm_address_country_id'] ) {
                    $rows[$rowNum]['civicrm_address_country_id'] = 
                        CRM_Core_PseudoConstant::country( $value );
                }
                $entryFound = true;
            }
            
            // convert display name to links
            if ( array_key_exists('civicrm_contact_sort_name', $row) && 
                 array_key_exists('civicrm_contact_id', $row) ) {
                $url = CRM_Report_Utils_Report::getNextUrl( 'contact/detail', 
                                                            'reset=1&force=1&id_op=eq&id_value=' . 
                                                            $row['civicrm_contact_id'],
                                                            $this->_absoluteUrl, $this->_id );
                $rows[$rowNum]['civicrm_contact_sort_name_link' ] = $url;
                $entryFound = true;
            }
            
            
            if ( array_key_exists( 'civicrm_activity_assignment_assignee_contact_id', $row ) ) {
                $rows[$rowNum]['civicrm_activity_assignment_assignee_contact_id' ] =
                    CRM_Utils_Array::value( $row['civicrm_activity_assignment_assignee_contact_id'], 
                                            CRM_Campaign_BAO_Survey::getInterviewers( ) );
                $entryFound = true;
                
            }
            
            
            if ( array_key_exists( 'civicrm_activity_survey_id', $row ) ) {
                $rows[$rowNum]['civicrm_activity_survey_id']  = 
                    CRM_Utils_Array::value( $row['civicrm_activity_survey_id'],
                                            CRM_Campaign_BAO_Survey::getSurveys( ) ); 
                $entryFound = true;
            }
            
            // skip looking further in rows, if first row itself doesn't 
            // have the column we need
            if ( !$entryFound ) {
                break;
            }
        }
        
    }
    /*
     * TODO - this can go as far as the turf report is concerned
     */
        private function _addSurveyResponseColumns( ) 
    {
        $surveyIds = CRM_Utils_Array::value( 'survey_id_value', $this->_params );
        if ( CRM_Utils_System::isNull( $surveyIds ) ||
             !CRM_Utils_Array::value( 'survey_response',  $this->_params['fields'] ) ) {
            return;
        }
        
        require_once 'CRM/Campaign/BAO/Survey.php';
        require_once 'CRM/Core/BAO/CustomField.php';
        $responseFields = array( );
        foreach ( $surveyIds as $surveyId ) {
            $responseFields += CRM_Campaign_BAO_survey::getSurveyResponseFields( $surveyId );
        }
        
        $responseFieldIds = array( );
        foreach ( array_keys( $responseFields ) as $key ) {
            $cfId = CRM_Core_BAO_CustomField::getKeyID( $key );
            if ( $cfId ) $responseFieldIds[$cfId] = $cfId;
        }
        if ( empty( $responseFieldIds ) ) return;
        
        $query ='
     SELECT  cg.extends, 
             cf.data_type, 
             cf.html_type,  
             cg.table_name,       
             cf.column_name,
             cf.time_format,
             cf.id as cfId,
             cf.option_group_id
       FROM  civicrm_custom_group cg 
INNER  JOIN  civicrm_custom_field cf ON ( cg.id = cf.custom_group_id )
      WHERE  cf.id IN ( '. implode( ' , ',  $responseFieldIds ).' )';   
        $response = CRM_Core_DAO::executeQuery( $query );
        $fildCnt = 1;
        while ( $response->fetch( ) ) {
            $resTable  = $response->table_name;
            $fieldName = "custom_{$response->cfId}";
            
            //need to check does these custom data already included.
            
            if ( !array_key_exists( $resTable, $this->_columns ) ) {
                $this->_columns[$resTable]['dao']     = 'CRM_Contact_DAO_Contact'; 
                $this->_columns[$resTable]['extends'] = $response->extends;
            }
            if ( !CRM_Utils_Array::value( 'alias', $this->_columns[$resTable] ) ) {
                $this->_columns[$resTable]['alias'] = "{$resTable}_survey_response"; 
            }
            if ( !is_array( $this->_columns[$resTable]['fields'] ) ) {
                $this->_columns[$resTable]['fields'] = array( );
            }
            if ( array_key_exists( $fieldName, $this->_columns[$resTable]['fields'] ) ) {
                $this->_columns[$resTable]['fields'][$fieldName]['required'] = true;
                $this->_columns[$resTable]['fields'][$fieldName]['isSurveyResponseField'] = true;
                continue;
            }
            

            $title = $responseFields[$fieldName]['title'];
            if ( in_array( $this->_outputMode, array( 'print', 'pdf' ) ) ) {
                $title = 'Q'.$fildCnt++;
            }
            
            $fldType = 'CRM_Utils_Type::T_STRING';
            if ( $response->time_format ) $fldType = CRM_Utils_Type::T_TIMESTAMP;
            $field = array( 'name'     => $response->column_name,
                            'type'     => $fldType,
                            'title'    => $title,
                            'label'    => $responseFields[$fieldName]['title'],
                            'dataType' => $response->data_type,
                            'htmlType' => $response->html_type,
                            'required' => true,
                            'alias'    => ($response->data_type == 'ContactReference') ?  $this->_columns[$resTable]['alias'] .'_contact' : $this->_columns[$resTable]['alias'],
                            'dbAlias'  => $this->_columns[$resTable]['alias'].'.'.$response->column_name,
                            'no_display' => true,
                            'isSurveyResponseField' => true );
            
            $this->_columns[$resTable]['fields'][$fieldName] = $field;
            $this->_aliases[$resTable] = $this->_columns[$resTable]['alias'];
        }
    }

    /*
     * Return pledge data in an html format or as an array - we only do html so that the rows view has enough of a lookin on this data to common sense checking
     * @deprecated - have switched to making SQL do this work except for the related contact
     */
    function _compile_pledge(&$row, &$contact_row, $return = 'html', $related = ''){
      if($related ){
        $related = 'related_';
      }
      $fields = array(date('m-d-Y',strtotime(CRM_Utils_Array::value("civicrm_{$related}pledge_{$related}pledge_create_date",$row) )),
                      CRM_Utils_Array::value("civicrm_{$related}pledge_{$related}amount",$row) ,
                      CRM_Utils_Array::value("civicrm_{$related}pledge_{$related}payment_amount_paid",$row),
                      CRM_Utils_Array::value("civicrm_{$related}pledge_{$related}contribution_type_id",$row),
                      CRM_Utils_Array::value("civicrm_{$related}value_{$related}pledge_data_27_custom_111",$row),
                      CRM_Utils_Array::value("civicrm_{$related}pledge_{$related}installments",$row),
                      CRM_Utils_Array::value("civicrm_{$related}value_{$related}pledge_data_27_custom_134",$row),
                      CRM_Utils_Array::value("civicrm_{$related}value_{$related}pledge_data_27_custom_105",$row),
                      CRM_Utils_Array::value("civicrm_{$related}value_{$related}pledge_data_27_custom_129",$row),
                 );

     
     if($return == 'array'){
         return $fields;
     }

     $html =  implode( " ", $fields) ;
     return $html;
    }

    /*
     * Create temporary table with the sum of payments for each pledge. Return Table name
     */
    function _create_temp_payments_table(){
      static $tempTable;
      if(!empty($tempTable)){
        return $tempTable;
      }
      $tempTable = 'tmp_table_payments' . rand(10,99);
       $tempPayments = CRM_Core_DAO::executeQuery(
       "CREATE TEMPORARY  TABLE $tempTable
       (SELECT pledge_id as pp_id, sum(actual_amount) as amount_paid
       FROM civicrm_pledge_payment payment             
       GROUP BY payment.pledge_id 
       ORDER BY NULL)");
       CRM_Core_DAO::executeQuery("ALTER TABLE $tempTable ADD INDEX (pp_id)");
       return $tempTable;
       
    }
    /*
     * Create temporary table of concatenated pledges against contact. Return Table name
     * TODO remove hard coding of fields including custom fields
     * Would expect these could be inherited from selection
     * TODO have also hard coded in setting "td" to "th" based on one custom field. (Check vs Charge)
     * Probably css would be better - could assign a class in here for each <td>?
     */
    function _create_temp_pledges_table(){
      static $tempTable;
      if(!empty($tempTable)){
        return $tempTable;
      }
      // TODO shouldn't be hard-coded
	    $option_group_id = 11; 
      $tempTable = 'tmp_table_pledges' . rand(10,99);
       $tempPayments = CRM_Core_DAO::executeQuery(
       "CREATE TEMPORARY  TABLE $tempTable
	     SELECT  contact_id, max(pledge.id) as latest_pledge_id, sum(amount_paid) as amount_paid,
	     SUBSTRING_INDEX(group_concat(
       concat('<td>',amount , '</td><td>', create_date, '</td><td>', 
                 amount_paid,'</td><td>',ct.name,'</td><td>', 
	               ov.name, '</td>',  IF (`pledge_type_select_111` = 'CH','<th>','<td>'), pledge_type_select_111,IF (`pledge_type_select_111` = 'CH','</th>','</td>'), '<td>',
                 installments, '</td><td>',
                 pledge_campaign_code_134,'</td><td>',
       department_select_105, '</td><td>',worker.display_name ,'</td>') ORDER BY create_date DESC SEPARATOR  '<tr></tr>' )
        ,'</tr>',5)
       as pledges , 
       amount, create_date,start_date, contribution_type_id,  ov.name, installments, pledge_campaign_code_134, department_select_105, 
       pledge_worker_129

       FROM (SELECT * FROM civicrm_pledge ORDER BY create_date DESC ) as pledge 

       LEFT JOIN civicrm_value_pledge_data_27 on   pledge.id  = entity_id
       LEFT JOIN civicrm_contact worker on worker.id = pledge_worker_129
       LEFT JOIN civicrm_contribution_type ct on ct.id = contribution_type_id
       LEFT JOIN civicrm_option_value ov ON (option_group_id = $option_group_id AND ov.value = contribution_type_id)
       LEFT JOIN  " .$this->_create_temp_payments_table() . " pp on pp.pp_id =  pledge.id  
       
	   GROUP BY pledge.contact_id 
	   ORDER BY NULL
	   
	   ");
	   
       CRM_Core_DAO::executeQuery("ALTER TABLE $tempTable ADD INDEX (contact_id)");
       return $tempTable;    
    }
    /*
     * This generates a temp table that allows the inclusion of more than one phone no.
     */
    function _create_temp_phones_table($separator = ","){
      static $tempTable;
      if(!empty($tempTable)){
        return $tempTable;
      }
       $tempTable = 'tmp_table_phone' . rand(10,99);
       $tempPayments = CRM_Core_DAO::executeQuery(
       "CREATE TEMPORARY  TABLE $tempTable
       (SELECT contact_id , GROUP_CONCAT(concat(phone,  ' (' ,civicrm_location_type.name, ')') ORDER BY is_primary DESC SEPARATOR '$separator') as phone
       FROM civicrm_phone p
       LEFT JOIN civicrm_location_type on location_type_id = civicrm_location_type.id    
       GROUP BY p.contact_id)");
       CRM_Core_DAO::executeQuery("ALTER TABLE $tempTable ADD INDEX (contact_id)");
       return $tempTable;
       
    }
}
    

