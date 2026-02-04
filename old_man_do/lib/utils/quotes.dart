class Quotes {
  static const List<String> dailyQuotes = [
    "The more you sweat in training, the less you bleed in battle. - Navy SEALs",
    "Discipline is choosing between what you want now and what you want most. - Abraham Lincoln",
    "It does not matter how slowly you go as long as you do not stop. - Confucius",
    "Pain is weakness leaving the body. - USMC",
    "He who conquers himself is the mightiest warrior. - Confucius",
    "Do not pray for an easy life, pray for the strength to endure a difficult one. - Bruce Lee",
    "Civilize the mind but make savage the body. - Chinese Proverb",
    "We suffer more often in imagination than in reality. - Seneca",
    "Excellence is not an act, but a habit. - Aristotle",
    "Stay Hard. - David Goggins",
    "Be water, my friend. - Bruce Lee",
    "Slow is smooth, smooth is fast. - Special Forces",
    "A warrior is worthless unless he rises above others and stands strong in the midst of a storm. - Yamamoto Tsunetomo",
    "Get comfortable being uncomfortable. - Navy SEALs",
    "Your body can stand almost anything. It’s your mind that you have to convince.",
    "Fatigue makes cowards of us all. - Vince Lombardi",
    "The only easy day was yesterday. - Navy SEALs",
    "To be a warrior is to learn to be genuine in every moment of your life. - Chogyam Trungpa",
    "Strategy without tactics is the slowest route to victory. Tactics without strategy is the noise before defeat. - Sun Tzu",
    "Invincibility lies in the defense; the possibility of victory in the attack. - Sun Tzu",
  ];

  static String getQuoteForToday() {
    final dayOfYear = int.parse(DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays.toString());
    return dailyQuotes[dayOfYear % dailyQuotes.length];
  }
}
