# Talenoter

---

## Slide 1 — Software Bliver Ikke Sikkert af at Stå Stille

Godmorgen. Jeg vil starte med én observation: software ældes ikke på samme måde som fysisk infrastruktur.
Et transportbånd bliver ikke en sikkerhedsrisiko ved at stå stille. Software gør. Hver dag et system kører upatched,
vokser kløften mellem hvad det ved om trusselsbilledet og hvad verden ved, en lille smule mere.

I over to årtier har BEUMER leveret software til logistik i verdensklasse på tværs af lufthavne, pakkefaciliteter og
luftfragt. Det software blev bygget til at løse datidens problemer. Det gjorde det godt. Men modellen der fulgte med
— sælg det, fork det, lad kunden tilpasse det — var bygget til en verden hvor sikkerhedssårbarheder var enkeltstående
begivenheder. Den verden eksisterer ikke længere. I dag vil jeg forklare hvad det betyder teknisk, hvad vi skal gøre
ved det, og hvad det betyder for menneskerne i denne organisation.

---

## Slide 2 — 500+

Lad mig give jer ét tal der sætter problemet i konkrete termer. Et system der ikke patches i et helt år
opsamler over 500 kendte, dokumenterede, indekserede sårbarheder med fungerende exploits tilgængelige.
Hver enkelt kan fungere som springbræt til den næste.

Dette er ikke et dramatisk estimat. Det er virkeligheden af hvad der sker når man deployer software og
derefter stopper med at opdatere det. Sikkerhedsforskning fortsætter. Dependency-sårbarheder offentliggøres.
OS-patches udgives. Alt det sker uanset om vi deltager eller ej. Fork-modellen gør det værre fordi patching
ikke er en deployment — det er en code merge. Det tager uger eller måneder. Det er dyrt og nemt at udskyde.
Udskudt ofte nok, stopper det med at ske overhovedet. Det er det problem vi løser i dag.

---

## Slide 3 — Fork-Modellen Er Problemet

Fork-modellen fungerede godt i to årtier fordi tilpasningsmuligheder var det der lod os vinde udbud
som konkurrenter ikke ville røre. Den fordel er reel og vi kasserer den ikke.

Men modellen har en strukturel fejl. Når en kunde kører deres egen modificerede version af vores software,
er en sikkerhedspatch ikke en deployment. Det er en code merge. Hver kundespecifik ændring skal forenes med
hvad vi har ændret på trunk. For komplekse sites med mange års akkumulerede ændringer kan det tage tusindvis
af timer. Arbejde der er så dyrt er nemt at udskyde. Udskudt ofte nok, stopper det helt.

Fra 2027 er det ikke bare et operationelt problem. EU's Cyber Resilience Act gør producenter ansvarlige for
sikkerhedsniveauet i deres software fem år efter levering. Fork-modellen giver os ikke et forsvarligt svar
på det spørgsmål. Så vi ændrer modellen.

---

## Slide 4 — Tre Lag. Alle Tre Betyder Noget.

Sikkerhedsrisiko i software eksisterer på tværs af tre adskilte lag og alle tre skal adresseres uafhængigt.
Ingen af dem kan erstatte de andre, og en svaghed i ét lag skaber en vej ind i det næste.

Lag 1 er operativsystemet — det base image containeren er bygget på. Controls: minimér hvad der er i
image'et, adskil build- og runtime-images, rebuild på et ugentligt cadence, scan kørende images løbende.

Lag 2 er dependencies — de tredjepartspakker og biblioteker vores kode er afhængig af. Supply chain-angreb
og package takeovers er nu regelmæssige begivenheder på tværs af NPM, PyPI, NuGet og Maven. Controls:
trusted mirrors, version locks ved build-tid, automatiseret opdateringsværktøj, SCA scanning.

Lag 3 er source code — hvad vores udviklere skriver. Her lever OWASP Top 10. SQL injection, broken
authentication, insecure direct object references. Controls er SAST-værktøj kombineret med en reel
review-kultur bygget omkring små pull requests. Over 300 ændrede linjer falder review-kvaliteten markant.
Det er en sikkerhedskontrol, ikke en procespræference.

Jeg vil bruge et øjeblik på hvert lag.

---

## Slide 5 — Operating System

For en moderne softwarevirksomhed er OS ikke noget der installeres på en server. Det er det base image
containeren bygges på og deployes fra. Og base images er ikke ens. Et standard Linux base image leveres
med apt-get, curl, SSH — værktøjer en angriber kan bruge til at installere software, kontakte en ekstern
server eller åbne en shell.

Løsningen er at minimere. Distroless eller hardened minimale base images indeholder kun det runtime-applikationen
har brug for. Intet andet. Virksomheder som Chainguard har bygget en forretning på at levere disse.

Multi-stage builds sikrer at de værktøjer man har brug for til at kompilere og teste software aldrig ender
i det endelige runtime image. Build-containeren har alt. Production-containeren har næsten ingenting.

Og så rebuilder vi. Hver uge. Uanset om der er shipper nye features. Base image age-metrikken er det der
fortæller os hvornår det cadence er ved at glide, inden det bliver et problem.

---

## Slide 6 — Dependencies

Lag 2 er den kode vi er afhængige af men ikke selv har skrevet. Ethvert produkt afhænger af et økosystem
af tredjepartsbiblioteker — autentifikation, kryptografi, HTTP clients, serialisering. Vi bruger dem fordi
det hverken er produktivt eller mere sikkert at bygge alt fra bunden.

Risikoen er at vi ikke kan auditere dem alle. Supply chain-angreb — hvor ondsindet kode stilles diskret ind
i en tidligere pålidelig pakke — er nu en regelmæssig begivenhed. Log4Shell ramte millioner af systemer
fordi et udbredt logging-bibliotek indeholdt en kritisk fejl der var gået ubemærket hen.

Vores fire controls: trusted mirrors der filtrerer hvad der overhovedet kan indgå i vores builds; version
locks så et build er deterministisk og ingen uventet ændring snigler sig ind mellem kørsler; Dependabot
så opdateringer sker rutinemæssigt frem for i en krise; og SCA scanning med Blackduck så vi har synlighed
over hvilke sårbarheder der allerede befinder sig i vores dependency tree. Målet er at holde dependency
drift lille og synlig.

---

## Slide 7 — Source Code

Lag 3 er den kode vores udviklere skriver hver dag. Dette er det lag ingen scanner fuldt ud forstår og
intet base image-opdatering kan fikse. Det er også her de mest pålideligt udnyttede sårbarheder i
production-software lever. SQL injection, broken authentication, insecure direct object references.
OWASP Top 10. Disse dukker op år efter år ikke fordi udviklere er skødesløse, men fordi de opstår
under pres og kompleksitet i det daglige udviklingsarbejde.

To praksisser udgør fundamentet. SAST — værktøjer som CodeQL og SonarQube — analyserer kode inden
den merges. Det fanger de gentagelige, mønsterbaserede fejl et værktøj kan genkende. Ikke alt. Men
en masse, pålideligt, til lav pris.

Den anden praksis er code review, og der er specifik forskning der er værd at kende. Review-kvaliteten
falder markant efterhånden som pull request-størrelsen vokser. Over 300 ændrede linjer begynder
reviewere at miste tråden. Over 1.000 linjer er et review stort set en formalitet. At holde PRs små
er derfor ikke bare god ingeniørhygiejne. Det er en sikkerhedskontrol. Man har brug for begge
praksisser. Ingen af dem er tilstrækkelig alene.

---

## Slide 8 — En Ren Container Er Værdiløs Hvis Den Aldrig Når Production

Vi har dækket hvordan vi sikrer det vi bygger. Tre lag, løbende scanning, et ugentligt cadence fra et
friskpatched base image. Men intet af det betyder noget hvis softwaren ikke kan nå kunden.

Under den nuværende model kræver det at nå kunden en code merge. Det er den flaskehals der gør det
ugentlige cadence umuligt. Så den anden halvdel af denne strategi handler om at erstatte fork-modellen
med en integrationsarkitektur der lader os imødekomme kundebehov uden nogensinde at modificere
core-containeren.

Der er tre værktøjer til det. Jeg gennemgår dem i præferencerækkefølge.

---

## Slide 9 — Tre Måder at Tilpasse Uden at Forke

Tre integrationsmønstre, ordnet efter præference. Vi starter med det simpleste og bevæger os kun
videre til det næste når det foregående reelt ikke kan løse problemet.

Sidecar er standarden. Den håndterer de operationelle hensyn der varierer pr. site — log routing,
auth tokens, secrets injection, metrics export — uden at røre main-containeren overhovedet.
Main-containeren forbliver generisk, umodificeret og på det ugentlige delivery cadence.

API'en er den anden mulighed. Når et site har brug for dybere integration — at udløse events, læse
tilstand, bygge egne værktøjer oven på vores domænelogik — eksponerer vi det gennem en versioneret
API-grænse. De bygger på deres side. Vi bygger på vores. Vores opdateringer bryder ikke deres
integrationer.

SDK'en er den sidste udvej og vi vil ikke investere i at bygge den før behovet fra rigtige kunder
er bevist. Den gør os til en dependency inde i deres container og skubber sikkerhedsansvaret over
mod dem. Jeg bruger et øjeblik på hver.

---

## Slide 10 — Sidecar

Sidecar er et Kubernetes-mønster. En sidecar container kører ved siden af main-applikationens container
i samme pod og deler dens netværks- og lagringskontekst. Den kan se alt hvad main-containeren producerer,
men main-containeren behøver ikke vide at sidecar'en eksisterer.

Hvert site vi deployer til har eksisterende infrastruktur vi ikke kan kontrollere: log aggregators,
SIEM-systemer, identity providers, monitoring-platforme. Vi ønsker ikke at erstatte dem. Vi ønsker at
forbinde os til dem. Sidecar'en er forbindelsespunktet. Log routing, håndtering af auth tokens,
secrets management, metrics export, audit logging — alt dette lever i sidecar'en. Main-containeren
skriver bare til stdout og læser sin konfiguration.

Sidecar'en eksponerer konfiguration, ikke kode. Et site udfylder værdier: hvilken log-destination,
hvilken identity provider, hvilke secrets der skal mountes. De ændrer ikke adfærd. De har ikke adgang
til vores interne funktioner.

I Kubernetes kan sidecar'en auto-injiceres af platform-operatoren. Den ankommer simpelthen ved siden af
main-containeren. Sites med modne platform-teams kan medbringe deres egen sidecar, forudsat den
overholder samme interface. For alle andre leverer vi en standard sidecar.

---

## Slide 11 — API Integration

Når sidecar'en ikke er nok — når et site har brug for at udløse handlinger i vores software, læse
operationel tilstand eller bygge egne værktøjer oven på vores domænelogik — eksponerer vi det
gennem en API-grænse.

Fire komponenter. En letvægts API gateway der håndhæver versionering og rate limiting. Et event
distribution lag til reaktive integrationer hvor HTTP polling ikke er passende. En OAuth2 identity
server så adgang er autoriseret konsistent på tværs af begge interfaces. Og en admin CLI så
site-administratorer kan administrere deres egen adgang uden afhængighed af os.

Modellen er bevidst meningsfuld. Den forsøger ikke at forbinde sig til hvilken som helst identity
provider eller gateway sitet allerede har. Den medbringer sin egen og forventer at sitet integrerer
til vores. Det er et bevidst valg: at tilpasse sig hvert sites eksisterende infrastruktur ville gøre
variation på tværs af sites dyr at vedligeholde.

Den kritiske begrænsning er API-versionering. Vores opdateringer må aldrig bryde en kørende
integration. Stærk versioneringsdisciplin på vores side betyder at vi kan shippe ugentligt og
deres systemer fortsætter med at virke.

---

## Slide 12 — To Kunder. Modstandens Vej.

Implementeringen starter ikke med en fuld migration. Den starter med to kunder, valgt bevidst.

Den nemmeste tilgængelige og den sværeste. Den nemmeste giver os et rent proof of concept — virker
pipelinen, dækker sidecar'en hvad et site faktisk har brug for, kan vi levere på et ugentligt cadence
i et rigtigt miljø? Den sværeste er den der fortæller os hvad vi endnu ikke ved. Hvor bryder modellen
sammen? Hvad byggede vi ikke som vi burde have?

Men vi vælger også de rigtige mennesker. På hvert site vil vi have én der starter skeptisk — en
integration lead eller site-administrator der skal overbevises. Når de er overbeviste, rejser deres
historie. Arkitekturdiagrammer overbeviser ikke mennesker. Andre mennesker gør.

Den første milepæl er bevidst snæver. Sidecar kun. Vi nægter at bygge det vi endnu ikke har bevist
er nødvendigt. Den friktion vi møder er data. Hvis sidecar'en viser sig utilstrækkelig og API
integration reelt er nødvendig, bygger vi den. Hvis ingen af kunderne har brug for API'en, finder
vi den næste sværeste kunde og spørger igen.

---

## Slide 13 — To Teams. Håndplukkede.

Internt starter vi med to små teams. Ikke hvem der er tilgængelige — håndplukkede.

Sidecar-teamet og pipeline-teamet. Valgt fordi de er nysgerrige, teknisk skarpe og respekterede
af menneskerne omkring dem. At blive bedt om at deltage i et af disse teams skal føles som
anerkendelse, ikke en rotation. Det er de mennesker der vil definere hvordan denne model rent
faktisk fungerer i praksis. Deres navne vil være knyttet til det der kommer ud af det.

Inden de rører en rigtig kunde arbejder begge teams på BEUMERs fysiske demo-setup. Demo-miljøet
er der hvor antagelser bryder sikkert. Sidecar-teamet vil opdage at deres konfigurationsoverflade
manglede noget indlysende. Pipeline-teamet vil finde at deres image rebuild tager længere tid end
forventet under realistisk load. Disse opdagelser på demo-riggen koster ingenting. De samme
opdagelser hos et customer site koster troværdighed.

Efterhånden som disse teams beviser modellen og begynder at levere til de første kunder, udvider
arbejdet sig organisk. Et API-team når sidecar'en reelt ikke er nok. Et platform-team når antallet
af aktive kunder overstiger manuel overvågning. Hvert nyt team arver en model der allerede
virker i production. Ingen starter fra bunden.

---

## Slide 14 — Anderledes Arbejde. Ikke Mindre.

Den nye model stiller andre krav til både arkitekter og udviklere. Jeg vil være direkte om hvad det er.

For arkitekter: jobbet skifter fra at designe skræddersyede løsninger pr. kunde til at eje grænsen.
Deres dybe viden om hvad individuelle sites har brug for forsvinder ikke — den bliver det der gør
dem gode til sidecar-design. At forstå hvilke krav der reelt kræver en custom integration og hvilke
der kan imødekommes med konfiguration der allerede findes. Den bedømmelse er den centrale arkitekturkompetence
i denne model. De overtager også ejerskabet af fitness functions — ikke som en rapporteringsopgave
men som et instrument til at aflæse sundheden af det de designede.

For udviklere: grænserne for jobbet udvider sig til at inkludere den infrastruktur deres kode shipper
inden i. Dockerfiles, Kubernetes manifests, Helm charts, pipeline-definitioner. Disse er ikke
platform-teamets ansvar der overdrages ved deployment. De er en del af produktet. En udvikler der
ikke kan tænke over hvordan deres kode bygges, scannes, pakkes og deployes udfører kun halvdelen
af jobbet.

Ingen af disse kompetencer er eksotiske. De er standardværktøjskassen for moderne softwarelevering.
Demo-riggen er der hvor begge roller begynder at udvide sig til production sikkert.

---

## Slide 15 — Fra Licens til Abonnement

Den kommercielle model skal ændre sig for at matche leveringsmodellen. En fast købspris gav mening
da software blev solgt én gang og kunden vedligeholdt det fra det tidspunkt fremad. Det giver ikke
mening når vi nu leverer en friskpatched, rebuildet container hver eneste uge.

Hvad kunder køber under den nye model er ikke en feature-release. Det er en løbende vedligeholdt
sikkerhedsposition. Hver uge bringer et nyt base image fra den seneste patchede kilde, opdaterede
dependency locks og et fuldt gennemløb af scanning-pipelinen. Nogle uger inkluderer det ny
funktionalitet. Hver uge inkluderer det aktuel sikkerhed.

Det ændrer også supportrelationen fundamentalt. Under den gamle model overdrog vi en binary og
trådte tilbage. Under den nye model er kritiske CVEs og sikkerhedshændelser vores problem at
løse på det ugentlige cadence. Vi er i et continuous delivery-forhold med hver aktiv kunde.
Det er et markant anderledes og stærkere value proposition — særligt i konteksten af CRA.

---

## Slide 16 — Fitness Functions

Arkitekturens sundhed måles løbende. Seks metrikker på tværs af tre risikoniveauer.

De to røde metrikker — dependency age og base image age — er de ledende indikatorer for det
sammensatte sårbarhedsproblem vi beskrev i starten. Når disse begynder at stige, driver systemet
tilbage mod den samme eksponeringsprofl fork-modellen skabte.

SAST findings og open PR count er amber. En voksende backlog af statisk analyse-fund betyder at
sårbarheder identificeres men ikke løses. Et voksende PR-antal betyder at integrationsgæld
akkumuleres.

PR age og median PR size er de metrikker der fortæller om ingeniørkulturen holder. Langlivede PRs
betyder at patches ikke når production. Store PRs betyder at review-kvaliteten forringes — og
review er en sikkerhedskontrol.

Det der gør disse til mere end et dashboard er det andet de gør: de skaber et fælles sprog. Når
udviklere og arkitekter tænker i de samme seks tal, sætter de samme tærskler og overvåger de
samme tendenser, bliver arkitekturen noget teams ejer sammen frem for noget der pålægges oppefra.

---

## Slide 17 — Uret Kører

EU's Cyber Resilience Act kommer ikke. Den er her. Vi er i 2026, hvilket betyder at
hændelsesrapporteringspligten allerede er i kraft. Hvis en alvorlig hændelse berører software vi
har produceret og leveret, er vi forpligtet til at underrette de relevante myndigheder. Det betyder
at vi skal vide hvad der kører hos hver kunde og hvad dens aktuelle sikkerhedsposition er. Under
fork-modellen har vi ikke den synlighed.

I 2027 træder loven fuldt ud i kraft. Al ny software solgt efter den dato skal leveres med en
aktiv, dokumenteret cybersikkerhedsstrategi der dækker de fem år efter anskaffelse. Ikke en formular.
En reel strategi med en leveringsmodel bag sig.

Fork-modellen gør ikke bare dette dyrt. Den gør det strukturelt umuligt. En kunde der forkede vores
software for tre år siden og aldrig mergede en opdatering kører et system vi ikke kan se, ikke kan
opdatere og ikke kan rapportere på. Hvis det system indeholder en aktivt udnyttet sårbarhed, gør CRA
spørgsmålet om hvem der er ansvarlig til et juridisk spørgsmål. Den strategi jeg har beskrevet i dag
er svaret på det spørgsmål.

---

## Slide 18 — Afslutning

Jeg vil afslutte med hvad jeg mener er den vigtigste enkelt sætning i hele denne strategi.

En abonnementsmodel med ugentlig levering, vedligeholdt af os, med fitness functions vi kan
rapportere på, er ikke bare bedre ingeniørkunst. Det er den eneste model der giver os et forsvarligt
svar når en regulator eller en kunde spørger: hvad er den aktuelle sikkerhedsposition for jeres
software, og hvordan ved I det?

Under den nuværende fork-model kan vi ikke besvare det spørgsmål. Vi ved ikke hvad der kører hos
kunderne. Vi kontrollerer ikke hvad der patches eller hvornår. Vi kan ikke rapportere på det.

Under den model jeg har beskrevet i dag, kan vi. Hvert site, hver uge, samme pipeline, samme
standarder, samme synlighed.

Regulatorerne har givet os en deadline. Arkitekturen giver os svaret. De to founding teams er
hvor vi starter. Demo-riggen er hvor vi beviser det. Tak.
