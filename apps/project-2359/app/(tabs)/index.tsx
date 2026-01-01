import { View, ScrollView } from 'react-native';
import { H2, H3, P, Muted, Large } from '@/components/ui/typography';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Search, Flame, Scan, Mic, Plus, FileText, BookOpen } from 'lucide-react-native';

export default function PulseDashboard() {
  return (
    <ScrollView className="flex-1 bg-white p-4">
      <View className="flex-row items-center justify-between mt-12 mb-6">
        <View>
          <H2>Hello, User</H2>
          <Muted>Ready to study today?</Muted>
        </View>
        <View className="flex-row items-center bg-gray-100 px-3 py-1 rounded-full">
          <Flame size={20} color="#f97316" />
          <Large className="ml-1">12</Large>
        </View>
      </View>

      <View className="relative mb-6">
        <View className="absolute left-3 top-3 z-10">
          <Search size={18} color="#6b7280" />
        </View>
        <Input
          placeholder="Search your notes, cards, or PDFs..."
          className="pl-10 bg-gray-50 border-none"
        />
      </View>

      <Card className="mb-6 bg-black">
        <CardHeader>
          <CardTitle className="text-white">Up Next</CardTitle>
          <CardDescription className="text-gray-400">50 Reviews Due • Biology Exam in 2 days</CardDescription>
        </CardHeader>
        <CardContent>
          <Button variant="secondary" className="w-full" label="Start Session" />
        </CardContent>
      </Card>

      <H3 className="mb-4">Quick Capture</H3>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mb-6">
        <Button variant="outline" className="mr-2 flex-row items-center">
          <Scan size={18} color="black" />
          <P className="ml-2">Scan Document</P>
        </Button>
        <Button variant="outline" className="mr-2 flex-row items-center">
          <Mic size={18} color="black" />
          <P className="ml-2">Voice Note</P>
        </Button>
        <Button variant="outline" className="mr-2 flex-row items-center">
          <Plus size={18} color="black" />
          <P className="ml-2">New Flashcard</P>
        </Button>
        <Button variant="outline" className="mr-2 flex-row items-center">
          <FileText size={18} color="black" />
          <P className="ml-2">Import PDF</P>
        </Button>
      </ScrollView>

      <H3 className="mb-4">Recent Projects</H3>
      <View className="flex-row flex-wrap justify-between">
        <Card className="w-[48%] mb-4">
          <CardHeader className="p-4">
            <BookOpen size={24} color="black" />
            <CardTitle className="text-lg mt-2">Anatomy</CardTitle>
            <Muted>85% Complete</Muted>
          </CardHeader>
        </Card>
        <Card className="w-[48%] mb-4">
          <CardHeader className="p-4">
            <BookOpen size={24} color="black" />
            <CardTitle className="text-lg mt-2">Calculus</CardTitle>
            <Muted>42% Complete</Muted>
          </CardHeader>
        </Card>
      </View>
    </ScrollView>
  );
}
