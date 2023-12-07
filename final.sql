1. select a.cod_cust AS COD_CUST,
                trim(b.cod_acct_no) AS COD_ACCT_NO,
                to_char(b.DAT_VALUE,'DDMMYYYY') AS DAT_VALUE ,
                b.DAT_VALUE AS VALUE_DATED,
                b.cod_drcr AS COD_DRCR,
                b.AMT_TXN AS AMT_TXN,
                REPLACE(b.TXT_TXN_DESC,'''','') AS TXT_TXN_DESC,
                b.COD_TXN_MNEMONIC AS COD_TXN_MNEMONIC,
                b.COD_TXN_LITERAL AS COD_TXN_LITERAL,
                a.cod_acct_no||to_char(b.dat_txn,'DD/Mon/YYYY hh:mi:ss')||b.ctr_updat_srlno||b.CTR_BATCH_NO||b.REF_SYS_TR_AUD_NO||b.REF_SUB_SEQ_NO AS TRAN_ID,
                to_char(b.DAT_post,'DDMMYYYY') AS DAT_POST
                from fcrlive_1.ch_acct_mast a , fcrlive_1.ch_nobook b, fcrlive_1.ba_bank_mast c
                where a.COD_PROD in('869','819','219')
                and a.cod_acct_no = b.cod_acct_no
                and b.cod_txn_mnemonic not in ('6501','9870','9871')
                and b.DAT_post = c.dat_process
                and (b.dat_txn between to_date(to_char(sysdate,'dd-MON-yyyy')|| ' 00:00:01','dd-MON-yyyy HH24:MI:SS')
                and to_date(to_char(sysdate,'dd-MON-yyyy')|| ' 20:00:00','dd-MON-yyyy HH24:MI:SS'))
                and lower(b.txt_txn_desc) not like '%reversal%'
                and lower(b.txt_txn_desc) not like '%interestrefund%'
                and a.flg_mnt_status = 'A'
                and a.cod_acct_no not in ('017286900000010','005886900000362','000586900000923','004886900000122') -- for Dorma Prog
                and b.cod_drcr = 'C'

2. select
               a.cod_cust AS COD_CUST,
               trim(b.cod_acct_no) AS COD_ACCT_NO,
               to_char(b.DAT_VALUE, 'DDMMYYYY') AS DAT_VALUE,
               to_char(b.DAT_VALUE, 'DDMMYYYY') AS VALUE_DATED,
               b.cod_drcr AS COD_DRCR,
               b.AMT_TXN AS AMT_TXN,
               REPLACE(b.TXT_TXN_DESC, '''', '') AS TXT_TXN_DESC,
               b.COD_TXN_MNEMONIC AS COD_TXN_MNEMONIC,
               b.COD_TXN_LITERAL AS COD_TXN_LITERAL,
               a.cod_acct_no || to_char(b.dat_txn, 'DD/Mon/YYYY hh:mi:ss') ||
               b.ctr_updat_srlno || b.CTR_BATCH_NO || b.REF_SYS_TR_AUD_NO ||
               b.REF_SUB_SEQ_NO AS TRAN_ID,
               to_char(b.DAT_post, 'DDMMYYYY') AS DAT_POST
               from fcrlive_1.ch_acct_mast a,
               fcrlive_1.ch_nobook    b,
                fcrlive_1.ba_bank_mast c
                where a.COD_PROD in ('869', '819', '219')
                and a.cod_acct_no = b.cod_acct_no
                and b.cod_txn_mnemonic not in ('6501', '9870', '9871')
                and b.DAT_post = case when  trunc(sysdate) = c.dat_process then c.dat_process-1
                else trunc(sysdate)-1 end
                 and (b.dat_txn between
                   to_date(to_char(sysdate - 1, 'dd-MON-yyyy') || ' 00:00:01',
                   'dd-MON-yyyy HH24:MI:SS') and
                   to_date(to_char(sysdate - 1, 'dd-MON-yyyy') || ' 23:59:59',
                   'dd-MON-yyyy HH24:MI:SS'))
               and lower(b.txt_txn_desc) not like '%reversal%'
               and a.flg_mnt_status = 'A'
               and a.cod_acct_no not in ('017286900000010','005886900000362','000586900000923','004886900000122')
               and b.cod_drcr = 'C'
