# -*- coding: utf-8 -*-

class Cthulhu < DiceBot
  setPrefixes(['CC(B)?\(\d+\)', 'CC(B)?.*','RES(B)?.*', 'CBR(B)?\(\d+,\d+\)','MAKE','MF','MAKEEX'])

  def initialize
    #$isDebug = true
    super
    @special_percentage  = 20
    @critical_percentage = 1
    @fumble_percentage   = 1
  end

  def gameName
    'クトゥルフ'
  end

  def gameType
    "Cthulhu"
  end

  def getHelpMessage
    return <<INFO_MESSAGE_TEXT
c=クリティカル値 ／ f=ファンブル値 ／ s=スペシャル

1d100<=n    c・f・sすべてオフ（単純な数値比較判定のみ行います）

・cfs判定付き判定コマンド

CC	 1d100ロールを行う c=1、f=100
CCB  同上、c=5、f=96

例：CC<=80  （技能値80で行為判定。1%ルールでcf適用）
例：CCB<=55 （技能値55で行為判定。5%ルールでcf適用）

・組み合わせロールについて

CBR(x,y)	c=1、f=100
CBRB(x,y)	c=5、f=96

・抵抗表ロールについて
RES(x-y)	c=1、f=100
RESB(x-y)	c=5、f=96

※故障ナンバー判定

・CC(x) c=1、f=100
x=故障ナンバー。出目x以上が出た上で、ファンブルが同時に発生した場合、共に出力する（テキスト「ファンブル＆故障」）
ファンブルでない場合、成功・失敗に関わらずテキスト「故障」のみを出力する（成功・失敗を出力せず、上書きしたものを出力する形）

・CCB(x) c=5、f=96
同上

------追加ダイスボット------

MAKE  ：探索者に必要なダイス一括振り
MAKEEX：探索者に必要なダイス一括振り(特徴表も同時に)
MF：特徴表

INFO_MESSAGE_TEXT
  end

  def rollDiceCommand(command)
    case command
    when /CCB/i
      # 5%
      @critical_percentage = 5
      @fumble_percentage   = 5
      return getCheckResult(command)
    when /CC/i
      # 1%
      @critical_percentage = 1
      @fumble_percentage   = 1
      return getCheckResult(command)
    when /RESB/i
      # 5%
      @critical_percentage = 5
      @fumble_percentage   = 5
      return getRegistResult(command)
    when /CBRB/i
      # 5%
      @critical_percentage = 5
      @fumble_percentage   = 5
      return getCombineRoll(command)
    when /RES/i
      # 1%
      @critical_percentage = 1
      @fumble_percentage   = 1
      return getRegistResult(command)
    when /CBR/i
      # 1%
      @critical_percentage = 1
      @fumble_percentage   = 1
      return getCombineRoll(command)
    when /MAKEEX/
      #特徴表
      output = MakeStatusEX()
      return output
    when /MAKE/
      #キャラ作成
      output = MakeStatus()
      return output
    when /MF/
      #特徴表
      output = MakeFeature()
      return output

    end

    return nil
  end

  def getCheckResult(command)

    output = ""
    broken_num = 0
    diff = 0

    if (/CC(B)?(\d+)<=(\d+)/i =~ command)
      # /\(\d+\)/の()はpattern-killerにカイシャクされるらしい
      broken_num = $2.to_i
      diff = $3.to_i
    elsif (/CC(B)?<=(\d+)/i =~ command)
      diff = $2.to_i
    end

    if (diff > 0)
      output += "(1D100<=#{diff})"

      if (broken_num > 0)
        output += " 故障ナンバー[#{broken_num}]"
      end

      total_n, = roll(1, 100)

      output += ' ＞ ' + "#{total_n}"
      output += ' ＞ ' + getCheckResultText(total_n, diff, broken_num)
    else
      # 1D100単純置換扱い
      # 要らないかも
      output += "(1D100)"
      total_n, = roll(1, 100)
      output += ' ＞ ' + "#{total_n}"
    end

    return output
  end

  def getCheckResultText(total_n, diff, broken_num = 0)

    result = ""
    diff_special = 0
    fumble = false

    if( @special_percentage > 0)
      # specialの値設定が無い場合はクリティカル/ファンブル判定もしない
      diff_special = (diff * @special_percentage / 100).floor
      if(diff_special < 1)
        diff_special = 1
      end
    end

    if((total_n <= diff) and (total_n < 100))

      result = "成功"

      if( diff_special > 0)
        if(total_n <= @critical_percentage)
          if(total_n <= diff_special)
            result = "決定的成功/スペシャル"
          else
            result = "決定的成功"
          end
        else
          if(total_n <= diff_special)
            result = "スペシャル"
          end
        end
      end

    else

      result = "失敗"

      if( diff_special > 0)
        if((total_n >= (101 - @fumble_percentage)) and (diff < 100))
          result = "致命的失敗"
          fumble = true
        end
      end

    end

    if(broken_num > 0)
      if(total_n >= broken_num)
        if(fumble)
          result += "/故障"
        else
          result = "故障"
        end
      end
    end

    return result
  end

  def getRegistResult(command)
    output = "1"

    return output unless(/RES(B)?([-\d]+)/i =~ command)

    value = $2.to_i
    target =  value * 5 + 50

    if(target < 5)
      return "(1d100<=#{target}) ＞ 自動失敗"
    end

    if(target > 95)
      return "(1d100<=#{target}) ＞ 自動成功"
    end

    # 通常判定
    total_n, = roll(1, 100)
    result =  getCheckResultText(total_n, target)

    return "(1d100<=#{target}) ＞ #{total_n} ＞ #{result}"
  end

  def getCombineRoll(command)
    output = "1"

    return output unless(/CBR(B)?\((\d+),(\d+)\)/i =~ command)

    diff_1 = $2.to_i
    diff_2 = $3.to_i

    total, = roll(1, 100)

    result_1 = getCheckResultText(total, diff_1)
    result_2 = getCheckResultText(total, diff_2)

    successList = ["決定的成功/スペシャル", "決定的成功", "スペシャル", "成功"]
    failList = ["失敗", "致命的失敗"]

    succesCount = 0
    succesCount += 1 if successList.include?( result_1 )
    succesCount += 1 if successList.include?( result_2 )
    debug("succesCount", succesCount)

    rank =
      if( succesCount >= 2 )
        "成功"
      elsif( succesCount == 1 )
        "部分的成功"
      else
        "失敗"
      end

    return "(1d100<=#{diff_1},#{diff_2}) ＞ #{total}[#{result_1},#{result_2}] ＞ #{rank}"
  end
  
  def MakeStatus()
  	#一括作成
  	#各種値
  	i_str, = roll(3, 6)
  	i_con, = roll(3, 6)
  	i_pow, = roll(3, 6)
  	i_dex, = roll(3, 6)
  	i_app, = roll(3, 6)
  	i_siz_dm, = roll(2, 6)
  	i_int_dm, = roll(2, 6)
  	i_edu_dm, = roll(2, 6)
  	i_siz = i_siz_dm + 6
  	i_int= i_int_dm + 6
  	i_edu= i_edu_dm + 3
  	i_san_luk=i_pow*5
  	i_ide=i_int * 5
  	i_kno=i_edu * 5
  	i_hp=(i_con+i_siz)/2
  	if((i_con+i_siz)%2 == 1)
  		i_hp=i_hp+1
  	end
  	i_db_dm=i_siz+i_str
  	s_db=""
  	#DB算出
  	if(i_db_dm<=12)
  		s_db="-1D6"
  	elsif(i_db_dm<=16)
  		s_db="-1D4"
  	elsif(i_db_dm<=24)
  		s_db="+0"
  	elsif(i_db_dm<=32)
  		s_db="+1D4"
  	else
  		s_db="+1D6"
  	end
  	
  	#ポイント算出
  	i_pro = i_edu * 20
  	i_inter = i_int *10
  	return "\nSTR:#{i_str} CON:#{i_con} \nPOW:#{i_pow} DEX:#{i_dex} \nAPP:#{i_app} SIZ:#{i_siz} \nINT:#{i_int} EDU:#{i_edu} \nHP:#{i_hp} MP:#{i_pow} \nSAN:#{i_san_luk} 幸運:#{i_san_luk} \n知識:#{i_kno} アイデア:#{i_ide} \nDB:#{s_db} \n職業ポイント:#{i_pro} 興味ポイント:#{i_inter}"
  end
  
  def MakeFeature()
  	fdice, = roll(1, 6)
  	
  	case fdice
  	when 1
  	table = [
    "【君は風邪を引かない】君は難しいことを考えず、元気いっぱいに育った。\n INT-1 CON+2",
    "【大きな体】生まれつき大きな体に恵まれている。\n SIZ+1",
    "【素早い】柔軟さと軽快さを併せ持っている。DEX+1 \n SIZ9以下の場合、素早い上に小柄であるため、DEX+2",
    "【オシャレ】何時も身だしなみに気を使っている。APP+1",
    "【天才】生まれつき頭の回転が速い。INT+1",
    "【強固な意思】何事にも動じない、強靭な精神の持ち主だ。\nSAN,POWは変動せずに現在正気度+5(MAX：99-<クトゥルフ神話>)",
    "【勉強家】貴方は日々学ぶことに精進している。EDU+1",
    "【幸運のお守り】幸運のお守りを持っている。(どんなものかはKPと相談)\n身につけている間POW+1。紛失もしくは破損でPOW-1。\nPOWの増減により<<幸運>>のみ変化、正気度ポイントは変化しない。",
    "【一族伝来の宝物】絵画、本、武器、家具などの個人的な宝物で、探索者やキャンペーンにとって特別な勝ちを持つものを有している。\n宝物はAFかもしれない。",
    "【予期せぬ協力者】探索者には、いかなる理由か自分に忠誠を尽くし、増援に来るかもしれない協力者が居る。\nKPが協力者の正体を決める。また協力者の影響力を1d100で決める\n(数字が大きいほど影響力がある)"
    ]
    result, number = get_table_by_nDx(table, 1, 10)
    if(number==10)
    	edice, = roll(1,100)
    	return "\n#{fdice}-#{number}:#{result}\n影響力：#{edice}"
    else
    	return "\n#{fdice}-#{number}:#{result}"
    end
    
  	when 2
  	  	table = [
    "【手先が器用】任意の<制作>一つの基本成功値を50%に変更(PLは分野を決めること)\nさらに<機械修理>及び<電気修理>に+10%",
    "【影が薄い】生まれつき目立たない。<忍び歩き>及び<隠れる>に+20%",
    "【親の七光り】名家の出身、または親が有名人かもしれない。<信用>に+20%",
    "【愛書家】あらゆるジャンルの蔵書を持っている。<図書館>に+20%。\nさらに、図書館に出かけなくても自宅で<図書館>ロールが出来る。",
    "【鋭い洞察力】優れた感覚の持ち主であるため、<目星>に+30%",
    "【アウトドア派】暇さえあれば季節を問わず、野外活動に繰り出している。\n<ナビゲート><博物学><追跡>に20%",
    "【珍しい技能】探索者は[INT*5]%の日常には役に立たないが特定の人を感心させるような技能を一つKPと相談し持つことが出来る。",
    "【芸術的才能】稽古事を小さい頃に習っていたか、実用ブログなどで人気を博している。\n任意の<芸術>1つに[INT*3]%加える。プレイヤーは専門分野を指定すること。",
    "【バイリンガル】日本以外の国で生活したことがある。\n[EDU*5]%を最大3つまでの<他の言語>技能に振り分けることが出来る。",
    "【前職】以前は別の職についていたか、幼少期になにか得難い体験をしている。\n[EDU*3]%を前職としてPLが決めた、職業上の技能に割り振ることが出来る。"
    ]
    result, number = get_table_by_nDx(table, 1, 10)
    return "\n#{fdice}-#{number}:#{result}"
    
  	when 3
  	  	table = [
    "【天気予報士】外を見て<アイデア>ロールに成功すれば、短い期間([1d6+1]時間)の正確な転機を予想できる。\n降水確率や風の向き・強さ、嵐の時間帯、雷の落下しやすい場所なども予測可能。",
    "【プロドライバー】小さい頃から乗り物で遊んでいた。\nあらゆる<運転>技能の基本成功率は50%である。",
    "【飛ばし屋】空間把握能力に優れている。\nあらゆる<運転>技能の基本成功率は50%である。",
    "【戦士】周囲の物はすべて武器だと考えている。\nあらゆる近接戦闘武器(肉弾攻撃は除く)の基本成功率は50%である。",
    "【重火器の達人】銃火器とはなにかの縁があり、普段から親しんでいる。\n火気技能5つ(拳銃、サブマシンガン、ショットガン、マシンガン、ライフル)の基本成功率は50%である。",
    "【格闘センスの持ち主】幼いときから道場で鍛えられてきた\n素手の格闘技脳3つ(キック、組付き、頭突き)の基本成功率は50%である。",
    "【俊敏】どんな時でも、鋭く素早く状況を把握できる。\n<回避>の基本成功率は、通常の[DEX*2]%ではなく[DEX*5]%である。",
    "【信頼の置ける人】探索者は自分の家族や友人などの仲間を見捨てたり粗末にしたりせず、可能な限り助けようとする人間だ。\nその評判が今後も続く限り、任意のコミュニケーション技能3つに+10%",
    "【スポーツ万能】1つの技能に+20%、3つの技能に+10%、合計4つの任意の運動系技能にボーナスを加える。",
    "【平凡な容姿】平凡な顔のため、他人の印象に残りにくい。<変装>に+20%。\n加えて、一度しかあったことのない相手ならば、相手が<アイデア>ロールに失敗すれば、「よくある顔です」と言い訳するだけで、別人としてごまかせる。"
    ]
    result, number = get_table_by_nDx(table, 1, 10)
    return "\n#{fdice}-#{number}:#{result}"
    
  	when 4
  	  	table = [
    "【目付きが悪い(D)】目つきが悪すぎて、知り合い以外から怖がられる。\nAPP-1 さらに<信用>-10%",
    "【方向音痴(D)】<ナビゲート>の基本成功率が1%になる。\n加えて成長ロールで成長させることは出来ない。",
    "【異性が苦手(D)】どうしても異性と上手く話ができない。\n異性に対する<言いくるめ><説得><信用>に-10%",
    "【動物に嫌われる(D)】独特の佇まいのせいで、大抵の動物は探索者を見るなり威嚇してくる。",
    "【不思議ちゃん(D)】突然突拍子もない言動で周囲を騒がせることがある。\n別の世界から来た精神交換者か、妄想が生み出した人格がしばしば表面に出ているのかもしれない。",
    "【寄せ餌(D)】人間以外の怪物に好かれやすい。\n誘拐されれば殺されずに監禁されるか、もっとひどい目にあうこともある。",
    "【メガネを掛けている(D)】探索者は常時メガネを必要とする。\nメガネを失えば、視覚に関する技能はKPの判断で-20%減少することがある。",
    "【大切なもの(D)】他人には価値の無いものだが、大切なものを何時も身につけている。\n失ったときには1/1D8の正気ポイントを失う。",
    "【暗黒の祖先(D)】邪悪な一族、カルティスト、カニバリスト、もしくは超自然クリーチャーの子孫である。\n1D100をロールし、結果が大きいほど、より邪悪な存在に成る。",
    "【夜に弱い(D)】夜は、すぐに眠くなる体質である。\n深夜零時を過ぎても活動しようとすれば、<アイデア>及び<知識>のロールの成功の範囲が1/2となる(端数切り上げ)\nただし、早起きは得意である。"
    ]
    result, number = get_table_by_nDx(table, 1, 10)
    bad, = roll(1, 6)
    bad = bad*10
    if(number==9)
    	edice, = roll(1,100)
    	return "\n#{fdice}-#{number}:#{result}\n邪悪度：#{edice}\n技能ポイント#{bad}点取得"
    else
    	return "\n#{fdice}-#{number}:#{result}\n技能ポイント#{bad}点取得"
    end
    
  	when 5
  	  	table = [
    "【動物に好かれる】独特の佇まいのおかげか、大抵の動物が懐いてくる。",
    "【斜め上からの発想】狂気に陥った場合、探索者は独特の感性により、原因となった恐怖に対して秘められた真実を見抜くことが出来る。\nKPはクライマックスで宇宙的恐怖の一端を教えてくれる    だろう。\nただし、クライマックス以外の場面では、何も教えてくれない可能性がある。",
    "【失敗は発明の母】技能ロールに「96」以上の出目を出して失敗した場合、直ちに特別な経験ロールを行う。\n失敗すれば0ポイント、成功で1ポイントの技能ポイントを得る。",
    "【ペット】探索者には、最愛のペットが居る。シナリオとシナリオの間、一緒に触れ合うことで、正気度ポイントを1D3ポイント増加させても良い。\n増加上限は能力値SANあるいは(99-<クトゥルフ    神話>)のうち低い方となる。",
    "【おおらか】嫌なことをすぐ忘れられる。\n精神科クリニックや療養所などでの正気度ポイントの回復が+1増加する。",
    "【異物への耐性】体内の免疫力が発達している。\n毒(POT)を抵抗表で競う際に、成功の範囲に+20%",
    "【潜水の名人】長時間息を止めていられる。\n窒息に対するCONロールの成功の範囲に+20%",
    "【大酒飲み】酒にはめっぽう強く、酔いにくい。\nアルコールを毒のように扱う場合、探索者はすべてのアルコール関連のPOTを1/2する(端数切り上げ)",
    "【ど根性】根性がある。あらゆる抵抗表を使用したロールで、成功する範囲に+5%",
    "【受け身】どんな時でも、きちんと受け身を取って被害を最小限に抑えることが出来る。\nショックのCONロール(基本ルルブP61)の成功範囲に+20%"
    ]
    result, number = get_table_by_nDx(table, 1, 10)
    return "\n#{fdice}-#{number}:#{result}"
    
  	when 6
  	  	table = [
    "【奇妙な幸運】クトゥルフ神話の神性や怪物がランダムに目標を攻撃する際に対象から除外される。\nただし、単独で攻撃される場合や範囲攻撃の中にいた場合は対象になる。",
    "【投擲の才能】<投擲>で投げることの出来る武器のダメージボーナスは通常の1/2ではなく、通常のダメージボーナスになる。",
    "【鋼の筋力】ダメージボーナスが一段階向上する\n([-1D4]なら[+0]に ただし[1D6]以上ある場合は一段階向上する代わりにダメージ+1付与)",
    "【実は生きていた】生き残る術に長けている。死からの生還(基本ルルブP64)のチャンスが通常の次ラウンドではなく、5ラウンド以内に伸びる。",
    "【急所を見抜く】狩人の素質を持っている。\n貫通の確立は、通常の1/5ではなく、1/2となる。\nただし、最大40%である。",
    "【急速な回復力】新陳代謝に優れている。耐久を回復するロールの結果に+1",
    "【不屈の精神力】気絶しても、次の各ラウンドの最初に[CON*2]ロールを行う。\n成功なら治療を受けずとも自分から目覚めて、そのラウンドから再び行動可能となる。",
    "【マニアコレクター】コイン、本、昆虫、芸術、歴史的な遺物などを収集している。\n任意のコレクションを一つ決める。その筋では有名人であり、<幸運>ロールに成功すれば相手にも共感を得ら    れて、感動を与えられるかもしれない。",
    "【行方不明の家族】探索者には行方不明の家族がおり、キャンペーンの間に現れるかもしれない。\n(例えば海で遭難した、異国で死んだと思われてる、など)",
    "【好意を寄せられている】シナリオに登場する誰かに好意を持たれる。\nKPの裁量で、誰が、何故好きなのかを決定する。\nどれほど好意を寄せられているかは1D100で決める(数字が大きいほど好き)"
    ]
    result, number = get_table_by_nDx(table, 1, 10)
    if(number==10)
    	edice, = roll(1,100)
    	return "\n#{fdice}-#{number}:#{result}\n好感度：#{edice}"
    else
    	return "\n#{fdice}-#{number}:#{result}"
    end
    
  	end
  end
  
  def MakeStatusEX()
		outputST = MakeStatus()
		outputFE1 = MakeFeature()
		outputFE2 = MakeFeature()
  	return "\n#{outputST}\n#{outputFE1}\n#{outputFE2}"
  end
  
end

