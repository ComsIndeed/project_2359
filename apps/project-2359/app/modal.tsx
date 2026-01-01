import { View } from 'react-native';
import { Link } from 'expo-router';
import { H2, P } from '@/components/ui/typography';
import { Button } from '@/components/ui/button';

export default function ModalScreen() {
  return (
    <View className="flex-1 items-center justify-center p-6 bg-white">
      <H2 className="mb-4">Quick Add</H2>
      <P className="text-center mb-8 text-gray-500">
        Create a new note, flashcard, or task instantly.
      </P>

      <View className="w-full space-y-4">
        <Button className="w-full mb-3" label="New Flashcard" />
        <Button variant="outline" className="w-full mb-3" label="Scan Document" />
        <Button variant="secondary" className="w-full mb-3" label="Voice Note" />
      </View>

      <Link href="/" dismissTo className="mt-8">
        <P className="text-gray-400 underline">Cancel</P>
      </Link>
    </View>
  );
}
