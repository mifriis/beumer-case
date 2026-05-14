#!/bin/bash
# BEUMER Case Presentation Builder
# Uses Marp + design.md principles to generate presentations

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SOURCE_FILE="case.md"
OUTPUT_HTML="presentation.html"
OUTPUT_PDF="presentation.pdf"
DESIGN_FILE="design.md"

echo -e "${BLUE}🚀 BEUMER Presentation Builder${NC}"
echo -e "${BLUE}================================${NC}\n"

# Check if marp is installed
if ! command -v marp &> /dev/null; then
    echo -e "${YELLOW}⚠️  Marp not found. Installing globally...${NC}"
    npm install -g @marp-team/marp-cli
fi

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${YELLOW}⚠️  $SOURCE_FILE not found${NC}"
    exit 1
fi

echo -e "${BLUE}📝 Source:${NC} $SOURCE_FILE"
echo -e "${BLUE}🎨 Design:${NC} $DESIGN_FILE"
echo ""

# Generate HTML
echo -e "${GREEN}▶ Building HTML presentation...${NC}"
marp "$SOURCE_FILE" -o "$OUTPUT_HTML"
echo -e "${GREEN}✓ $OUTPUT_HTML created${NC}\n"

# Optional: Generate PDF
if [ "$1" == "--pdf" ]; then
    echo -e "${GREEN}▶ Building PDF presentation...${NC}"
    marp "$SOURCE_FILE" -o "$OUTPUT_PDF"
    echo -e "${GREEN}✓ $OUTPUT_PDF created${NC}\n"
fi

echo -e "${GREEN}✓ Done!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Open: open $OUTPUT_HTML"
echo "2. Edit: Update $SOURCE_FILE with your content"
echo "3. Rebuild: ./build.sh"
echo ""
echo -e "${BLUE}Design principles:${NC} See $DESIGN_FILE"
