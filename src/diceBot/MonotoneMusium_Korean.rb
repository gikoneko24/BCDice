# -*- coding: utf-8 -*-

class MonotoneMusium_Korean < DiceBot
  setPrefixes(['2D6.*', 'ET','ET2', 'OT', 'DT', 'DT2', 'WDT'])

  def initialize
    super

    @sendMode = 2
    @d66Type = 1
    @sortType = 1
  end

  def gameName
    '모노톤 뮤지엄'
  end

  def gameType
    "MonotoneMusium:Korean"
  end

  def getHelpMessage
    return <<INFO_MESSAGE_TEXT
・판정
　・통상판정　　　　　　2D6+m>=t[c,f]
　　수정치m,목표치t,크리티컬치c,펌블치f로 판정 굴림을 행합니다.
　　크리티컬, 펌블치는 생략가능합니다. ([]자체를 생략가능)
　　자동성공, 자동실패, 성공, 실패를 자동표기합니다.
・각종표
　・감정표　ET／감정표 2.0　ET2
　・징조표　　OT
　・일그러짐표　DT／일그러짐표ver2.0　DT2
　・세계왜곡표　　WDT
・D66다이스 있음
INFO_MESSAGE_TEXT
  end

  def rollDiceCommand(command)
    result = checkRoll(command)
    return result unless(result.empty?)

    debug("판정롤이 아닙니다")

    debug("각종표로써 처리")
    return rollTableCommand(command)
  end

  def checkRoll(string)
    output = ''

    crit = 12
    fumble = 2

    return output unless(/^2D6([\+\-\d]*)>=(\d+)(\[(\d+)?(,(\d+))?\])?$/i =~ string)

    modText = $1
    target = $2.to_i
    crit = $4.to_i if($4)
    fumble = $6.to_i if($6)

    mod = 0
    mod = parren_killer("(0#{modText})") unless( modText.nil? )

    total, dice_str, = roll(2, 6, @sortType && 1)
    total_n = total + mod.to_i

    output = "#{total}[#{dice_str}]＋#{mod} → #{total_n}"

    if(total >= crit)
      output += " ＞ 자동 성공"
    elsif(total <= fumble)
      output += " ＞ 자동 실패"
    elsif(total_n >= target)
      output += " ＞ 성공"
    else
      output += " ＞ 실패"
    end

    output = "(#{string}) ＞ #{output}"

    return output
  end

  def rollTableCommand(command)
    output = ''
    type = ""

    case command
    when /ET2/i
      type ="감정표2.0"
      output, total_n = mm_emotion_table_ver2()
    when /ET/i
      type ="감정표"
      output, total_n = mm_emotion_table()
    when /OT/i
      type ="징조표"
      output, total_n = mm_omens_table()
    when /DT2/i
      type = "일그러짐표ver2.0"
      output, total_n = mm_distortion_table_ver2()
    when /WDT/i
      type = "세계왜곡표"
      output, total_n = mm_world_distortion_table()
    when /DT/i
      type = "징조표"
      output, total_n = mm_distortion_table()
    end

    output = "#{type}(#{total_n}) ＞ #{output}" if(output != '')

    return output
  end

  # 감정표(d66)[ET]
  def mm_emotion_table
    table = [
      "【신뢰(信頼)】",
      "【유위(有為)】",
      "【우정(友情)】",
      "【순애(純愛)】",
      "【자애(慈愛)】",
      "【동경(憧れ)】",
      "【공포(恐怖)】",
      "【위협(脅威)】",
      "【증오(憎悪)】",
      "【불쾌감(不快感)】",
      "【식상(食傷)】",
      "【혐오(嫌悪)】",
      "【호의(好意)】",
      "【비호(庇護)】",
      "【유지(遺志)】",
      "【회고(懐旧)】",
      "【진력(尽力)】",
      "【충성(忠誠)】",
      "【불안(不安)】",
      "【모멸(侮蔑)】",
      "【질투(嫉妬)】",
      "【열등감(劣等感)】",
    "【우월감(優越感)】",
    "【연민(憐憫)】",
      "【존경(尊敬)】",
      "【감복(感服)】",
      "【모정(慕情)】",
      "【동정(同情)】",
      "【심취(傾倒)】",
      "【호기심(好奇心)】",
      "【편애(偏愛)】",
      "【집착(執着)】",
      "【회개(悔悟)】",
      "【경계심(警戒心)】",
    "【적개심(敵愾心)】",
    "【망각(忘却)】",
    ]
    return get_table_by_d66(table)
  end

  # 감정표2.0(d66)[ET2]
  def mm_emotion_table_ver2
    table = [
      "【플레이어의 임의】",
      "【동일시(同一視)】",
      "【연대감(連帯感)】",
      "【행복감(幸福感)】",
      "【친근감(親近感)】",
      "【성의(誠意)】",
      "【회고(懐旧)】",
      "【동향(同郷)】",
      "【동지(同志)】",
      "【악연(くされ縁)】",
      "【기대(期待)】",
      "【호적수(好敵手)】",
      "【빌려(借り)】",
      "【대여(貸し)】",
      "【헌신(献身)】",
      "【의형제(義兄弟)】",
      "【어린 아이(幼子)】",
      "【친애(親愛)】",
      "【소외감(疎外感)】",
      "【치욕(恥辱)】",
      "【연민(憐憫)】",
      "【격의(隔意)】",
      "【혐오(嫌悪)】",
      "【시의심(猜疑心)】",
      "【염기(厭気)】",
      "【불신감(不信感)】",
      "【원한(怨念)】",
      "【비애(悲哀)】",
      "【악의(悪意)】",
      "【살의(殺意)】",
      "【패배감(敗北感)】",
      "【헛수고감(徒労感)】",
      "【뒷 마음(黒い泥)】",
      "【분만(憤懣)】",
      "【무관심(無関心)】",
      "【플레이어의 임의】",
    ]
    return get_table_by_d66(table)
  end

 # 징조표(2d6)[OT]
  def mm_omens_table
    table = [
      "【신념의 상실】\n［출신］을 상실한다. 특징은 없어지지 않는다.",
      "【졸도】\n［전투불능］이 된다.",
      "【육체의 붕괴】\n2D6 점의 HP를 잃는다.",
      "【방심】\n배드 스테이터스［방심］을 받는다.",
      "【중압】\n배드 스테이터스［중압］을 받는다.",
      "【현재의 상실】\n현재 가지고 있는 파트너 한 명을 상실한다.",
      "【마비】\n배드 스테이터스[마비]를 받는다.",
      "【사독】\n배드 스테이터스[사독] 5를 받는다.",
      "【색채의 상실】\n칠흑、묵백、투명화……. 그 두려운 색채의 상실은 틀림없는 이형화의 편린이다.",
      "【이유의 상실】\n［처지］를 상실한다. 특징은 없어지지 않는다.",
      "【존재의 상실】\n당신의 존재는 일순간, 이 세계로부터 소실한다.",
    ]

    return get_table_by_2d6(table)
  end

  # 일그러짐표(2D6)[DT]
  def mm_distortion_table
    table = [
      "【세계소실】\n연극의 무대가 모두 없어진다. 무대에 남아있는 것은 너희들과 이형, 가람뿐이다. 클라이맥스 페이즈로.",
      "【생명감소】\n연극의 무대에 있는 거리나 나라로부터 동물이나 인간의 모습이 적어진다. 특히 아이들의 모습을 볼 수 없다.",
      "【공간소실】\n연극의 무대 일부(건물 한 개 동 정도)가 소실한다.",
      "【날씨악화】\n격렬한 뇌우에 휩쓸린다.",
      "【생명번무】\n씬 내에 식물이 폭발적으로 증가하고, 건물은 가시나무의 가시와 덩굴풀에 파묻힌다.",
      "【색채상실】\n세계로부터 색채가 없어진다. 방적공(PC)이외의 사람들은 세계의 모든 것이 모노크롬처럼 되었다고 인식한다.",
      "【신권음악】\n아름답지만 불안을 느끼는 소리가 흐른다. 소리는 사람들에게 스트레스를 주어 거리의 분위기가 악화하고 있다.",
      "【경면세계】\n연극의 무대에 존재하는 모든 문자는 거울처럼 역전된다.",
      "【시공왜곡】\n밤낮이 역전한다. 낮이면 밤이 되고, 밤이면 아침이 된다.",
      "【존재수정】\nGM이 임의로 결정한 NPC의 성별이나 연령, 외관이 변화한다.",
      "【인체소실】\n씬 플레이어의 파트너로 되어있는 NPC가 소실한다. 어느 NPC가 소실되는지는 GM이 결정한다.",
    ]
    return get_table_by_2d6(table)
  end

  # 일그러짐표ver2.0(d66)[DT2]
  def mm_distortion_table_ver2
    table = [
      "【색채침식】\n씬 내에 존재하는 모든 무생물과 생물은 흰색과 흑백으로 이루어진 모노톤의 존재가 된다. 방적공은 【봉제】 난이도 8의 판정에 성공하면 이 영향을 받지 않는다. 이 효과는 일그러짐을 가져온 이형의 죽음에 의해서 해제된다.",
    "【색채침식】\n씬 내에 존재하는 모든 무생물과 생물은 흰색과 흑백으로 이루어진 모노톤의 존재가 된다. 방적공은 【봉제】 난이도 8의 판정에 성공하면 이 영향을 받지 않는다. 이 효과는 일그러짐을 가져온 이형의 죽음에 의해서 해제된다.",
      "【허무출현】\n일그러짐 중에서 허무가 배어 나온다. 씬에 등장하고 있는 엑스트라는 벌레 한 마리에 이르기까지 소멸해서 두 번 다시 나타나지 않는다.",
      "【허무출현】\n일그러짐 중에서 허무가 배어 나온다. 씬에 등장하고 있는 엑스트라는 벌레 한 마리에 이르기까지 소멸해서 두 번 다시 나타나지 않는다.",
      "【계절변용】\n계절이 갑자기 변화한다. 1D6을 굴려서 1이라면 봄, 2라면 여름, 3이라면 가을, 4라면 겨울, 5라면 플레이하고 있는 현재의 계절, 6이라면 GM의 임의대로 변한다.",
      "【계절변용】\n계절이 갑자기 변화한다. 1D6을 굴려서 1이라면 봄, 2라면 여름, 3이라면 가을, 4라면 겨울, 5라면 플레이하고 있는 현재의 계절, 6이라면 GM의 임의대로 변한다.",
      "【일그러짐】\n세계에 금이 가서 일그러짐이 출현한다. 일그러짐에 접한 것은 허무에 삼켜져 돌아올 일은 없다.",
      "【일그러짐】\n세계에 금이 가서 일그러짐이 출현한다. 일그러짐에 접한 것은 허무에 삼켜져 돌아올 일은 없다.",
      "【이형화】\n씬 내에 모든 엑스트라는 어떠한 이형화를 받는다. 이것을 치유 할 방법은 없다. 이형의 무리（『인카르챤드』 P.237）×1D6와 전투시켜도 좋다.",
      "【이형화】\n씬 내에 모든 엑스트라는 어떠한 이형화를 받는다. 이것을 치유 할 방법은 없다. 이형의 무리（『인카르챤드』 P.237）×1D6와 전투시켜도 좋다.",
      "【죽음의 행진】\n사람들의 마음에 허무가 퍼져, 불안과 절망으로 채워져 간다. 피할 수 없는 공포로부터 피하려고 사람들은 스스로 혹은 무의식중에 죽음을 향해 행동을 시작한다.",
      "【죽음의 행진】\n사람들의 마음에 허무가 퍼져, 불안과 절망으로 채워져 간다. 피할 수 없는 공포로부터 피하려고 사람들은 스스로 혹은 무의식중에 죽음을 향해 행동을 시작한다.",
      "【시간가속】\n씬 내에 존재하는 모든 무생물과 생물은 2D6년만큼 시간이 가속한다. 생물이라면 노화한다. 방적공은 【봉제】 난이도 8의 판정에 성공하면 이 영향을 받지 않는다.",
      "【시간가속】\n씬 내에 존재하는 모든 무생물과 생물은 2D6년만큼 시간이 가속한다. 생물이라면 노화한다. 방적공은 【봉제】 난이도 8의 판정에 성공하면 이 영향을 받지 않는다.",
      "【시간역류】\n씬 내에 존재하는 모든 무생물과 생물은 2D6년만큼 시간이 역류한다. 생물이라면 젊어진다. 제조년/생년보다 앞으로 돌아왔을 때는 허무에 삼켜져서 소멸한다. 방적공은 【봉제】 난이도 8의 판정에 성공하면 이 영향을 받지 않는다.",
      "【시간역류】\n씬 내에 존재하는 모든 무생물과 생물은 2D6년만큼 시간이 역류한다. 생물이라면 젊어진다. 제조년/생년보다 앞으로 돌아왔을 때는 허무에 삼켜져서 소멸한다. 방적공은 【봉제】 난이도 8의 판정에 성공하면 이 영향을 받지 않는다.",
      "【재해도래】\n폭풍우, 화산분화, 홍수 등, 흐트러짐에 의해서 어지럽혀진 자연이 사람들에게 송곳니를 드러낸다.",
      "【재해도래】\n폭풍우, 화산분화, 홍수 등, 흐트러짐에 의해서 어지럽혀진 자연이 사람들에게 송곳니를 드러낸다.",
      "【인심황폐】\n일그러짐에 의해 초래된 불안과 공포는 사람들을 자포자기하게 한다.",
      "【인심황폐】\n일그러짐에 의해 초래된 불안과 공포는 사람들을 자포자기하게 한다.",
      "【평온무사】\n아무것도 일어나지 않는다. 방적공들은 등골이 오싹할 정도의 공포를 느낀다.",
      "【평온무사】\n아무것도 일어나지 않는다. 방적공들은 등골이 오싹할 정도의 공포를 느낀다.",
      "【역병만연】\n등장하고 있는 캐릭터는 【육체】 난이도 8의 판정을 하여 실패하면 ［사독］5를 받는다. 병의 치료법의 유무 등에 대해서는 GM이 결정한다. 고민된다면 가람을 쓰러트리면 병도 소멸한다, 라고 하라.",
      "【역병만연】\n등장하고 있는 캐릭터는 【육체】 난이도 8의 판정을 하여 실패하면 ［사독］5를 받는다. 병의 치료법의 유무 등에 대해서는 GM이 결정한다. 고민된다면 가람을 쓰러트리면 병도 소멸한다, 라고 하라.",
      "【이단심문】\n이단심문의 시기가 가깝다. PC들이 방적공인 것이 알려진다면, PC들도 화형대로 보내지게 될 것이다.",
      "【이단심문】\n이단심문의 시기가 가깝다. PC들이 방적공인 것이 알려진다면, PC들도 화형대로 보내지게 될 것이다.",
      "【일그러짐출현】\n흐트러짐의 파편으로부터 일그러짐이 나타나 사람들을 습격한다. 병마（『인카르챤드』 P.238）×2와 전투를 하게 해도 좋다. 또, 다른 이형이라도 좋다.",
      "【일그러짐출현】\n흐트러짐의 파편으로부터 일그러짐이 나타나 사람들을 습격한다. 병마（『인카르챤드』 P.238）×2와 전투를 하게 해도 좋다. 또, 다른 이형이라도 좋다.",
      "【악몽출현】\n씬 내의 모든 사람은 무서운 공포의 꿈을 꾼다. 마음 약한 사람들은 가람에 매달리던가, 이단자들을 화형에 처하는 것으로 이 꿈에서 벗어날 수 있을 거로 생각할 것이다.",
      "【악몽출현】\n씬 내의 모든 사람은 무서운 공포의 꿈을 꾼다. 마음 약한 사람들은 가람에 매달리던가, 이단자들을 화형에 처하는 것으로 이 꿈에서 벗어날 수 있을 거로 생각할 것이다.",
      "【쥐의 연회】\n다수의 쥐의 떼가 출현하여 곡물을 들쑤셔 먹고 역병을 흩뿌린다. 대형 쥐（『MM』 P.240）×1D6와 전투를 하게 해도 좋다.",
      "【쥐의 연회】\n다수의 쥐의 떼가 출현하여 곡물을 들쑤셔 먹고 역병을 흩뿌린다. 대형 쥐（『MM』 P.240）×1D6와 전투를 하게 해도 좋다.",
      "【왜곡길잡이표】\n삐뚤어진 길잡이표가 내려진다. 일그러짐표（『MM』 P.263）를 굴릴 것.",
      "【왜곡길잡이표】\n삐뚤어진 길잡이표가 내려진다. 일그러짐표（『MM』 P.263）를 굴릴 것.",
      "【지역소멸】\n연극의 무대가 되는 지역 그 자체가 사라져서 없어진다. 영향 아래에 있는 모든 캐릭터(가람을 포함한다)는 【봉제】 난이도 10의 판정에 성공하면 탈출할 수 있다. 실패했을 경우 그 즉시 사망한다. 엑스트라는 무조건 사망한다.",
      "【지역소멸】\n연극의 무대가 되는 지역 그 자체가 사라져서 없어진다. 영향 아래에 있는 모든 캐릭터(가람을 포함한다)는 【봉제】 난이도 10의 판정에 성공하면 탈출할 수 있다. 실패했을 경우 그 즉시 사망한다. 엑스트라는 무조건 사망한다.",
    ]
    return get_table_by_d66(table)
  end

  # 世界歪曲表(2D6)[WDT]
  def mm_world_distortion_table
    table = [
      "【소실】\n세계로부터 보스 캐릭터가 소거되어 소멸한다. 엔딩 페이즈로 직행.",
      "【자기희생】\n표를 굴린 PC의 파트너로 되어있는 NPC 중 1명이 사망한다. 표를 굴린 PC의 HP와 MP를 완전회복시킨다.",
      "【생명탄생】\n그대들은 대지 대신에 무엇인가의 생물의 내장 위에 서있다. 등장하고 있는 캐릭터 전원에게 ［사독］5를 준다.",
      "【왜곡확대】\n씬에 등장하고 있는 방적공이 아닌 NPC 하나가 칠흑의 흉수（『MM』 P.240）로 변신한다.",
      "【폭주】\n“흐트러짐”이 대량으로 생겨나 씬에 등장하고 있는 모든 캐릭터의 박리치를 +1 한다.",
      "【환상세계】\n주위의 공간이 삐뚤어져 파괴적인 에너지가 충만하다. 다음에 행해지는 대미지 산출에 +5D6한다.",
      "【변조】\n오른쪽은 왼쪽으로, 빨강은 파랑으로, 위는 아래로, 일그러짐이 신체의 움직임을 방해한다. 등장하고 있는 캐릭터 전원에게 ［낭패］를 준다.",
      "【공간소실】\n연극의 무대가 연기와도 같이 소실된다. 압도적인 상실감에 의해 등장하고 있는 캐릭터 전원에게 ［방심］을 준다.",
      "【생명소실】\n다음 씬 이후, 엑스트라는 일절 등장할 수 없다. 현재의 씬의 엑스트라에 관해서는 GM이 결정한다.",
      "【자기사(自己死)】\n가장 박리치가 높은 PC 하나가 ［전투불능］이 된다. 복수의 PC가 해당했을 때는 GM이 랜덤으로 결정한다.",
      "【세계사(世界死)】\n세계의 파멸. 난이도 12의 【봉제】 판정에 성공하면 파멸로부터 회피할 수 있다. 실패하면 행방불명이 된다. 엔딩 페이즈로 직행.",
    ]

    return get_table_by_2d6(table)
  end
end
