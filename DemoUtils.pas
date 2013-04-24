//  Copyright (C) 2003  ABplus Inc. kazHIDA.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  1. Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer
//     as the first lines of this file unmodified.
//  2. Redistributions  in  binary  form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
//  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
//  The following is Japanese.
//  �ȉ��́A���{���
//
//  �\�[�X���邢�̓o�C�i���[�`���ł̍Ĕz�z/�g�p�́A���ς�������ꍇ���A
//  �����Ȃ��ꍇ���A���L�̏����𖞂������ꍇ�ɋ��������B
//
//  1.  �\�[�X�R�[�h�ł̍Ĕz�z���ɂ́A�K����L�̒��쌠�\���A���̏������X�g�A
//      ����шȉ��̖Ɛӎ������A���ς����ɂ��̃t�@�C���̍ŏ��̐��s�ɓ����
//      ����΂Ȃ�Ȃ��B
//  2.  �o�C�i���[�`���ł̍Ĕz�z�́A�K����L�̒��쌠�\���A���̏������X�g�A
//      �ȉ��̖Ɛӎ����̕������h�L�������e�[�V�������A���邢�͔z�z���Ƌ���
//      �񋟂������̂Ɋ܂߂Ȃ���΂Ȃ�Ȃ��B
//
//  ���̃\�t�g�E�F�A�́A����҂ɂ��A�u����̂܂܁v�Œ񋟂���A
//  ����҂͒��ړI�A�񒼐ړI�A�����I�A����ȁA�T�^�I�A���邢�͕K�R��
//  �����Ȃ�ꍇ�ɂ����Ă��A�����Ȃ鑹�Q�Ɉ�ؐӔC�͕���Ȃ��B
//  ���̑��Q�͈ȉ��̓��e���܂݁A����������Ɍ��肳��Ȃ��B
//  ��p�ƂȂ镨��T�[�r�X�̒��B�A���ʁE�f�[�^�E���v�̒ቺ�A������̏�Q�A
//  �܂��A�ǂ̂悤�ȐӖ��̘_���ɂ����Ă��A���ꂪ�_��Ɋւ�����̂ł��낤�ƁA
//  ���i�ȐӖ��ł��낤�ƁA�s���s�ׁi�s���ӂ₻�̑��̏ꍇ���܂ށj�ł��낤�ƁA
//  ���̃\�t�g�E�F�A���g�p���邱�Ƃɂ���Đ����邻���̑��Q�́A
//  ��؂̐ӔC���璘��҂͖Ƃ�Ă���B
//  ���Ƃ����O�ɂ���炷�ׂĂ̑��Q�ւ̉\������������Ă����ꍇ�ɂ����Ă�
//  ���l�ł���B
//
unit DemoUtils;
//  $Id: DemoUtils.pas 270 2003-03-11 02:52:54Z kazhida $
//  $Author: kazhida $


interface

//function ResTypeComment(var rb: PSdsResBuf): Integer;
//function ResTypetoType(var rb: PSdsResBuf): Integer;
//  �ʂ�interface���̐錾�������Ă�����(�����Ă���������)

implementation

uses
  SDScore;


function ResTypeInfo(var rb: PSdsResBuf): Integer;
var
  s: String;
begin
  s := '';
  if Assigned(rb) then
  begin
    case SdsResTypeToBufType(rb.restype) of
      SdsRInt, SdsRLong:
      begin
        s := SdsResTypeToComment(rb.rint);
        case SdsResTypeToBufType(rb.rint) of
          SdsRReal:   s := s + '�y�����z';
          SdsRPoint:  s := s + '�y3D(�܂���2D)���W�z';
          SdsRInt:    s := s + '�y16bit�����z';
          SdsRString: s := s + '�y������(�������|�C���^)�z';
          SdsRName:   s := s + '�y�G���e�B�e�B��(64bit����)�z';
          SdsRLong:   s := s + '�y32bit�����z';
          SdsRBinary: s := s + '�y�o�C�i���f�[�^�z';
        else          s := s + '�y�킩��Ȃ��z';
        end;
      end;
    end;
  end;
  if s = ''
  then sds_retnil
  else sds_retstr(PChar(s));
  Result := SDS_RTNORM;
end;


initialization
  //  ����ȕ��Ƀ��j�b�g�̏��������œo�^����
  SdsAddUserFunc('restypeinfo',   ResTypeInfo);
end.
